# Mod colocation checkpoint

Owner approved local checkpoints, a plain-source import into `mod/STS2MCP`, path updates,
checks and a combined commit. No push, game-mod installation, game requests or real
inference occurred.

## Preserved checkpoints

- App before import: `3cfe5d26a2c7d325560c032ed63c9867f468f55b` (`main`). Includes the
  other session's completed, owner-approved Oxlint/Oxfmt/CI work; that session confirmed
  it had no active writer and remained read-only during colocation.
- Mod: `96597ec7c5431591f989317baf73e64e53b906ab` on `checkpoint/jev-minimal-demo`,
  based on upstream `55e064850a68f3b4cde7e5fd525bf9b2dec4e885`. Sibling left intact.

The app checkpoint includes existing evidence byte-for-byte. `git diff --cached --check`
reported only captured HTTP header CRLF/terminal blank lines; these were deliberately
preserved rather than altering hashed evidence. The same check excluding `docs/evidence`
passed. `.gitattributes` prevents text conversion of captured evidence. The import likewise
preserves one preexisting trailing space in `UPSTREAM.md` (`[!NOTE]`); the import's
whitespace check excluding that verbatim archive passed.

## Import and verification

- **33/33 imported files byte-identical**, including all 25 production C# inputs and the
  project, solution, manifest, license, build helper and existing 1909-check harness.
  Source README preserved as `UPSTREAM.md`. See `import-manifest.json`.
- New local README documents root-relative build/test commands and upstream/license
  provenance. No nested Git repository, submodule, copied game assembly or generated output.
- Source bootstrap, ownership, input, tutorial and task policies were not edited.
- **505/505 historical hashed captures verified** across the three M2 live-evidence
  manifests. See `evidence-check.json`.

Exact commands/exits are in `verification-commands.jsonl`; complete output is alongside it.
All six commands exited **0**:

| Check | Result |
| --- | --- |
| Documented root-relative .NET build | 0 warnings/errors |
| Imported compiled-DLL harness | 1909 checks pass; no game initialization/HTTP |
| Oxlint | Pass |
| Oxfmt | Pass, 28 files |
| TypeScript 7 typecheck | Pass |
| Bun 1.4.2 tests | 50 pass, 193 assertions |

Every Bun command used `--no-env-file`, and typecheck used `--no-install`. Validation
processes inherited only PATH/HOME. No Bun package installation was repeated. Test
transports were fake loopback/provider fixtures. Native build disabled parent
Directory.Build imports and deployment; game DLLs were local compile/metadata references.

`imported-dll.sha256` identifies this pre-commit working-tree build at the app checkpoint
above. A normal build embeds the repository revision and source paths, so relocation or
another commit can change the DLL hash even with identical source; it is not asserted to
match the old sibling candidate hash. The generated DLL was not committed or installed.

`.env`, downloaded sources and native `bin/obj/out` products remain ignored. No credential
contents were inspected for this task. Live Jev/Ancient acceptance and broader M2 coverage
remain pending; offline checks are not gameplay acceptance.
