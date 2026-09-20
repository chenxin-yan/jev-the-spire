// HTTP client for the forked STS2MCP bridge (McpMod.Contract.cs / BridgeProtocol.cs).
// GET returns the current observation; POST {state_version,label} dispatches one legal action.

export const BRIDGE_URL = "http://127.0.0.1:15526/api/v1/singleplayer";

const HTTP_TIMEOUT_MS = 10_000;
const READ_ATTEMPTS = 3;
const READ_RETRY_DELAY_MS = 1_000;
// Server backoff beyond this halts the demo instead of waiting.
const MAX_RETRY_AFTER_MS = 10_000;

export interface LegalAction {
  readonly label: string;
  readonly description: string;
}

export interface Snapshot {
  readonly state_type: string;
  readonly terminal: boolean;
  readonly waiting?: boolean;
  readonly halt_reason?: string;
  readonly legal_actions_complete: boolean;
  readonly legal_actions: ReadonlyArray<LegalAction>;
  readonly state_version: string;
  readonly mutation_pending: boolean;
  readonly seed?: string;
  readonly run?: { readonly act: number; readonly floor: number; readonly ascension: number };
  readonly visible_text?: string;
  readonly [key: string]: unknown;
}

export interface DispatchResult {
  readonly status: number;
  readonly body: unknown;
}

export class MalformedSnapshotError extends Error {
  override readonly name = "MalformedSnapshotError";
}

const isRecord = (value: unknown): value is Record<string, unknown> =>
  typeof value === "object" && value !== null && !Array.isArray(value);

export const parseSnapshot = (value: unknown): Snapshot => {
  if (!isRecord(value)) throw new MalformedSnapshotError("observation is not an object");
  if (typeof value.state_type !== "string") throw new MalformedSnapshotError("state_type missing");
  if (typeof value.state_version !== "string" || value.state_version === "") {
    throw new MalformedSnapshotError("state_version missing");
  }
  if (typeof value.terminal !== "boolean") throw new MalformedSnapshotError("terminal missing");
  if (typeof value.legal_actions_complete !== "boolean")
    throw new MalformedSnapshotError("legal_actions_complete missing");
  if (typeof value.mutation_pending !== "boolean")
    throw new MalformedSnapshotError("mutation_pending missing");
  if (!Array.isArray(value.legal_actions))
    throw new MalformedSnapshotError("legal_actions missing");
  const labels = new Set<string>();
  for (const action of value.legal_actions) {
    if (
      !isRecord(action) ||
      typeof action.label !== "string" ||
      typeof action.description !== "string"
    ) {
      throw new MalformedSnapshotError("legal action must have string label and description");
    }
    if (labels.has(action.label))
      throw new MalformedSnapshotError(`duplicate legal action label ${action.label}`);
    labels.add(action.label);
  }
  // Optional fields the loop dereferences must have the documented type when present (nulls are omitted by the bridge).
  for (const [key, type] of [
    ["waiting", "boolean"],
    ["halt_reason", "string"],
    ["seed", "string"],
    ["visible_text", "string"],
  ] as const) {
    if (value[key] !== undefined && typeof value[key] !== type)
      throw new MalformedSnapshotError(`${key} must be a ${type}`);
  }
  if (
    value.run !== undefined &&
    (!isRecord(value.run) ||
      typeof value.run.act !== "number" ||
      typeof value.run.floor !== "number")
  ) {
    throw new MalformedSnapshotError("run must be an object with numeric act and floor");
  }
  return value as Snapshot;
};

// Retry-After is delta-seconds or an HTTP-date (RFC 9110 §10.2.3). Undefined means header absent/unparseable.
export const retryAfterMs = (header: string | null, now = Date.now()): number | undefined => {
  if (header === null) return undefined;
  const seconds = Number(header);
  if (Number.isFinite(seconds) && seconds >= 0) return seconds * 1_000;
  const date = Date.parse(header);
  return Number.isNaN(date) ? undefined : Math.max(0, date - now);
};

const requestSignal = (signal: AbortSignal) =>
  AbortSignal.any([signal, AbortSignal.timeout(HTTP_TIMEOUT_MS)]);

const sleep = (ms: number, signal: AbortSignal) =>
  new Promise<void>((resolve, reject) => {
    // An already-aborted signal never fires "abort"; fail immediately instead of waiting out the timer.
    if (signal.aborted) return reject(signal.reason);
    const timer = setTimeout(() => {
      signal.removeEventListener("abort", onAbort);
      resolve();
    }, ms);
    const onAbort = () => {
      clearTimeout(timer);
      reject(signal.reason);
    };
    signal.addEventListener("abort", onAbort, { once: true });
  });

// Reads may retry a bounded number of times (contract #6: ~3 attempts, honor Retry-After).
export const observe = async (
  url: string,
  signal: AbortSignal,
  fetchImpl: typeof fetch = fetch,
): Promise<Snapshot> => {
  let lastError: unknown;
  for (let attempt = 1; attempt <= READ_ATTEMPTS; attempt++) {
    signal.throwIfAborted();
    let delayMs = READ_RETRY_DELAY_MS;
    let response: Response | undefined;
    try {
      response = await fetchImpl(url, { method: "GET", signal: requestSignal(signal) });
    } catch (error) {
      if (signal.aborted) throw error;
      lastError = error;
    }
    if (response !== undefined) {
      // Malformed JSON propagates as a halt; only transport failures and 429/5xx are retried.
      if (response.status === 200) return parseSnapshot(await response.json());
      if (response.status !== 429 && response.status < 500) {
        throw new Error(`bridge GET returned ${response.status}`);
      }
      const retryAfter = retryAfterMs(response.headers.get("retry-after"));
      if (retryAfter !== undefined) {
        if (retryAfter > MAX_RETRY_AFTER_MS) {
          throw new Error(
            `bridge GET returned ${response.status} with Retry-After ${retryAfter}ms over the ${MAX_RETRY_AFTER_MS}ms budget`,
          );
        }
        delayMs = retryAfter;
      }
      lastError = new Error(`bridge GET returned ${response.status}`);
    }
    if (attempt < READ_ATTEMPTS) await sleep(delayMs, signal);
  }
  throw lastError;
};

// Mutations are sent exactly once. Any thrown error (timeout, network) leaves the outcome
// uncertain and the caller must halt; the bridge consumes the version on accept so a replay is 409 anyway.
export const dispatch = async (
  url: string,
  stateVersion: string,
  label: string,
  signal: AbortSignal,
  fetchImpl: typeof fetch = fetch,
): Promise<DispatchResult> => {
  const response = await fetchImpl(url, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ state_version: stateVersion, label }),
    signal: requestSignal(signal),
  });
  const text = await response.text();
  let body: unknown = text;
  try {
    body = JSON.parse(text);
  } catch {
    // Non-JSON rejection bodies are kept verbatim for the log.
  }
  return { status: response.status, body };
};
