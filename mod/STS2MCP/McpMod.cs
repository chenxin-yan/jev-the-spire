using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Text.Encodings.Web;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading;
using System.Threading.Tasks;
using Godot;
using HarmonyLib;
using MegaCrit.Sts2.Core.Modding;
using MegaCrit.Sts2.Core.Multiplayer.Game;

namespace STS2_MCP;

[ModInitializer("Initialize")]
public static partial class McpMod
{
    public const string Version = "0.4.0";
    public const int DefaultPort = 15526;
    private const string ConfigFileName = "STS2_MCP.conf";

    private static HttpListener? _listener;
    private static Thread? _serverThread;
    private static readonly MainThreadRequests _mainThreadQueue = new();
    internal static readonly JsonSerializerOptions _jsonOptions = new()
    {
        WriteIndented = true,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull,
        PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
        Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping
    };

    private static int LoadPort()
    {
        try
        {
            string? modDir = Path.GetDirectoryName(
                System.Reflection.Assembly.GetExecutingAssembly().Location);
            if (modDir == null) return DefaultPort;

            string configPath = Path.Combine(modDir, ConfigFileName);
            if (!File.Exists(configPath))
            {
                try
                {
                    var defaultConfig = new Dictionary<string, object> { ["port"] = DefaultPort };
                    string json = JsonSerializer.Serialize(defaultConfig, _jsonOptions);
                    File.WriteAllText(configPath, json);
                    GD.Print($"[STS2 MCP] Created default config at {configPath}");
                }
                catch (Exception ex) when (ex is UnauthorizedAccessException or IOException)
                {
                    GD.Print($"[STS2 MCP] No config found at {configPath}; using default port {DefaultPort}");
                }
                return DefaultPort;
            }

            string content = File.ReadAllText(configPath);
            using var doc = JsonDocument.Parse(content);
            if (doc.RootElement.TryGetProperty("port", out var portElem)
                && portElem.TryGetInt32(out int port)
                && port is > 0 and <= 65535)
            {
                return port;
            }

            GD.PrintErr($"[STS2 MCP] Invalid or missing 'port' in {configPath}, using default {DefaultPort}");
            return DefaultPort;
        }
        catch (Exception ex)
        {
            GD.PrintErr($"[STS2 MCP] Failed to load config: {ex.Message}, using default port {DefaultPort}");
            return DefaultPort;
        }
    }

    public static void Initialize()
    {
        try
        {
            // Optional settings UI patches should not block the HTTP bridge itself.
            TryApplyHarmonyPatches();
            // Required for owned child decisions; failure must prevent the gameplay listener starting.
            InstallSelectionOwnershipHooks();

            // Connect to main thread process frame for action execution
            var tree = (SceneTree)Engine.GetMainLoop();
            tree.Connect(SceneTree.SignalName.ProcessFrame, Callable.From(ProcessMainThreadQueue));

            int port = LoadPort();

            _listener = new HttpListener();
            _listener.Prefixes.Add($"http://localhost:{port}/");
            _listener.Prefixes.Add($"http://127.0.0.1:{port}/");
            _listener.Start();

            _serverThread = new Thread(ServerLoop)
            {
                IsBackground = true,
                Name = "STS2_MCP_Server"
            };
            _serverThread.Start();

            GD.Print($"[STS2 MCP] v{Version} server started on http://localhost:{port}/");
        }
        catch (Exception ex)
        {
            GD.PrintErr($"[STS2 MCP] Failed to start: {ex}");
        }
    }

    private static void TryApplyHarmonyPatches()
    {
        try
        {
            new Harmony("com.sts2mcp").PatchAll();
        }
        catch (Exception ex)
        {
            GD.Print(
                $"[STS2 MCP] Optional Harmony settings UI injection skipped: {ex.GetType().Name}: {ex.Message}");
        }
    }

    private static void ProcessMainThreadQueue() => _mainThreadQueue.Drain(10);

    internal static Task<T> RunOnMainThread<T>(Func<T> func)
        => _mainThreadQueue.Enqueue(func, CancellationToken.None);

    internal static Task RunOnMainThread(Action action)
        => RunOnMainThread(() => { action(); return true; });

    private static T RequestOnMainThread<T>(Func<T> work)
    {
        using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(5));
        return _mainThreadQueue.Enqueue(work, timeout.Token).WaitAsync(timeout.Token).GetAwaiter().GetResult();
    }

    private static void ServerLoop()
    {
        while (_listener?.IsListening == true)
        {
            try
            {
                var context = _listener.GetContext();
                // Handle each request asynchronously so we don't block the listener
                ThreadPool.QueueUserWorkItem(_ => HandleRequest(context));
            }
            catch (HttpListenerException) { break; }
            catch (ObjectDisposedException) { break; }
        }
    }

    private static void HandleRequest(HttpListenerContext context)
    {
        try
        {
            var request = context.Request;
            var response = context.Response;
            int rejection = BridgeProtocol.CheckRequest(request.HttpMethod,
                request.Url?.AbsolutePath ?? "/", request.Headers["Origin"],
                Array.Find(request.Headers.AllKeys, key => key?.StartsWith("Sec-Fetch-", StringComparison.OrdinalIgnoreCase) == true),
                request.ContentType);
            if (rejection != 0)
            {
                SendError(response, rejection, "Request outside the gameplay bridge boundary");
                return;
            }

            if (request.HttpMethod == "GET")
                HandleGetState(request, response);
            else
                HandlePostAction(request, response);
        }
        catch (Exception ex)
        {
            try
            {
                SendError(context.Response, 500, $"Internal error: {ex.Message}");
            }
            catch { /* response may already be closed */ }
        }
    }

    // Called on HTTP thread (not main thread) as a best-effort guard.
    // The try/catch handles race conditions during run transitions.
    // Authoritative checks happen inside RunOnMainThread lambdas.
    internal static bool IsMultiplayerRun()
    {
        try
        {
            return MegaCrit.Sts2.Core.Runs.RunManager.Instance.IsInProgress
                && MegaCrit.Sts2.Core.Runs.RunManager.Instance.NetService.Type.IsMultiplayer();
        }
        catch { return false; }
    }

    private static void HandleGetMultiplayerState(HttpListenerRequest request, HttpListenerResponse response)
    {
        string format = request.QueryString["format"] ?? "json";

        try
        {
            var stateTask = RunOnMainThread(() => BuildMultiplayerGameState());
            var state = stateTask.GetAwaiter().GetResult();

            if (format == "markdown")
            {
                string md = FormatAsMarkdown(state);
                SendText(response, md, "text/markdown");
            }
            else
            {
                SendJson(response, state);
            }
        }
        catch (Exception ex)
        {
            GD.PrintErr($"[STS2 MCP] HandleGetMultiplayerState: {ex}");
            try
            {
                response.StatusCode = 500;
                SendJson(response, new Dictionary<string, object?>
                {
                    ["error"] = $"Failed to read multiplayer game state: {ex.Message}",
                    ["exception_type"] = ex.GetType().FullName,
                    ["stack_trace"] = ex.StackTrace
                });
            }
            catch { /* response may be unusable */ }
        }
    }

    private static void HandlePostMultiplayerAction(HttpListenerRequest request, HttpListenerResponse response)
    {
        string body;
        using (var reader = new StreamReader(request.InputStream, request.ContentEncoding))
            body = reader.ReadToEnd();

        Dictionary<string, JsonElement>? parsed;
        try
        {
            parsed = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(body);
        }
        catch
        {
            SendError(response, 400, "Invalid JSON");
            return;
        }

        if (parsed == null || !parsed.TryGetValue("action", out var actionElem))
        {
            SendError(response, 400, "Missing 'action' field");
            return;
        }

        string action = actionElem.GetString() ?? "";

        // Menu actions (FTUE/popup dismissal, game-over, character select, etc.) are
        // scene-tree-driven and equally valid in MP. Route them to the shared handler
        // so MP clients can dismiss blocking FTUE prompts without going through the
        // run-mode-specific dispatcher.
        if (action == "menu_select")
        {
            try
            {
                var option = parsed.TryGetValue("option", out var optElem) ? optElem.GetString() ?? "" : "";
                var seed = parsed.TryGetValue("seed", out var seedElem) ? seedElem.GetString() : null;
                var resultTask = RunOnMainThread(() => ExecuteMenuSelect(option, seed));
                var result = resultTask.GetAwaiter().GetResult();
                SendJson(response, result);
            }
            catch (Exception ex)
            {
                SendError(response, 500, $"Menu action failed: {ex.Message}");
            }
            return;
        }

        try
        {
            var resultTask = RunOnMainThread(() => ExecuteMultiplayerAction(action, parsed));
            var result = resultTask.GetAwaiter().GetResult();
            SendJson(response, result);
        }
        catch (Exception ex)
        {
            SendError(response, 500, $"Multiplayer action failed: {ex.Message}");
        }
    }

    private static void HandleGetState(HttpListenerRequest request, HttpListenerResponse response)
    {
        try { SendJson(response, RequestOnMainThread(() => CaptureObservation().State)); }
        catch (OperationCanceledException) { SendError(response, 504, "Observation timed out; halt"); }
        catch (Exception) { SendError(response, 500, "Observation failed; halt"); }
    }

    private static void HandlePostAction(HttpListenerRequest request, HttpListenerResponse response)
    {
        try
        {
            using var reader = new StreamReader(request.InputStream, Encoding.UTF8);
            var buffer = new char[8193];
            int count = reader.ReadBlock(buffer, 0, buffer.Length);
            if (count > 8192) { SendError(response, 413, "Action body too large"); return; }
            var command = BridgeProtocol.ParseAction(new string(buffer, 0, count));
            var result = RequestOnMainThread(() => DispatchLabel(command.Version, command.Label));
            response.StatusCode = result.Code;
            SendJson(response, result.Body);
        }
        catch (JsonException) { SendError(response, 400, "Expected state_version and label strings only"); }
        catch (OperationCanceledException) { SendError(response, 504, "Dispatch outcome unknown; halt and never retry blind"); }
        catch (Exception) { SendError(response, 500, "Dispatch failed; halt and never retry blind"); }
    }
}
