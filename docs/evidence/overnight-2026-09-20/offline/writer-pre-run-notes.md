# Direct tool commands before the retained runner

- `pwd; git status --short; git rev-parse HEAD; git diff --cached --name-only`: exit 0; cwd requested checkout, HEAD d89dfdadc18056cbd977e546f54ab7002f48b5e0, clean tree/index. Ancestor AGENTS.md existence checks found no additional file.
- `shasum -a 256 '/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/data_sts2_macos_arm64/sts2.dll'`: exit 0, 9cb4f1ad8c9f284aa8fec3122ffd6d780bbf543d875c817abdd12ff63fbf12b4.
- Copied existing canonical Release DLL to baseline.dll and original harness to baseline-check.sh before edits. Baseline SHA256 f1762a3fd659cca1fc4b5c0773f26c0ab628c94a23a898d2f7846e81fe55e217.
- `mise exec -- dotnet /tmp/jev-m1-safety-code/IlProbe.dll <literal native path above> MegaCrit.Sts2.Core.Nodes.Potions.NPotionHolder .ctor _Ready OnRelease OpenPotionPopup AddPotion DisableUntilPotionRemoved CancelPotionUseOrDiscard RemoveUsedPotion '<GrayPotionHolderUntilPlayedAfterDelay>d__37' '<UsePotion>d__41' '<TargetNode>d__42' ShouldCancelTargeting`: exit 0; holder.il.
- `mise exec -- dotnet /tmp/jev-m1-safety-code/IlProbe.dll <literal native path above> MegaCrit.Sts2.Core.Nodes.Screens.Map.NMapScreen Open`: exit 0; map-open.il.
- An attempted shell-variable batch passed an empty native-path argument to five probes (FieldWriters, Callers, IlProbe Holder.Create, PotionModel.IsValidTarget/EnqueueManualUse, Popup._Ready/RefreshButtons). Each exited 134 with `System.ArgumentException: Path "" is not an absolute path. (Parameter 'assemblyPath')` before loading the assembly. All five were rerun successfully through run.py with a literal path substitution; commands.jsonl contains exact corrected argv/exits and separate .log files. The empty initial .il files from this batch are not evidence; use holder-create.log, potion-model.log and popup.log instead.

# Later harness iteration

After initial green (1938 checks), adding owned-child coverage introduced a C# local-name clash (`childVersion`, CS0136). The two final-green/final-red attempts exited 1 during harness compilation, not product execution. Renamed this harness local to decisionChildVersion. Retained final-green-fixed = 1950 checks / exit 0 and final-red-fixed = expected assertion / exit 134. No production code iteration was needed.

All evidence was generated offline. Probes inspect metadata/IL only; the harness invokes managed bridge/session helpers, not native scene constructors or Godot. The assembly loader prints the existing Sentry `GDExtension not loaded ... skipping` diagnostic. No application/provider/game requests, credentials, environment inspection, settings/save reads, package installation or deployment occurred.
