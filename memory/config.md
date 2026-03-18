# PMM Configuration

Settings that control how Poor Man's Memory behaves.
Run `/pmm-settings` at any time to change these.

## Save Cadence

<!-- How often memory is updated -->
- Mode: every-milestone
<!-- Options: every-milestone | every-N-messages (specify N) | on-request-only -->
<!-- Note: For fine-grained control, use /loop with /pmm-save (e.g. /loop 5m /pmm-save) -->

## Commit Behaviour

<!-- When changes are committed to git -->
- Mode: auto-commit
<!-- Options: auto-commit | session-end | manual -->

## Push Behaviour

<!-- Should memory commits be automatically pushed to the remote? -->
- Auto-push: off
<!-- Options: off (default) | on -->
<!-- off: commits stay local — push manually when ready -->
<!-- on: git push runs after every memory commit (failures are reported, not swallowed) -->

## Sliding Window Size

<!-- Max entries in windowed files (timeline, summaries) before trimming -->
- Timeline max: 50
- Summaries max: 10
<!-- Presets: light (30/5) | moderate (50/10) | heavy (100/20) | unlimited -->

## Verbosity

<!-- How memory updates are communicated -->
- Mode: silent
<!-- Options: silent | summary | verbose -->

## Repository Visibility

<!-- Is this repository public or private? Controls PII handling in memory files. -->
- Visibility: public
<!-- Options: public | private -->
<!-- public: maintain agent avoids personal emails, uses handles over full names, summarises sensitive decisions -->
<!-- private: no PII restrictions, full fidelity -->

## Maintain Agent Model

<!-- Which model handles memory updates (maintain phase) -->
- Model: haiku
<!-- Options: haiku (default, cheapest) | sonnet (balanced) | opus (most capable) -->
<!-- Session-start and recall agents always use the parent model -->

## Active Files

<!-- Which memory files are active. Deactivated files are not created or loaded. -->
<!-- config.md and BOOTSTRAP.md are always active. -->
- memory.md: active
- assets.md: active
- decisions.md: active
- processes.md: active
- preferences.md: active
- voices.md: active
- lessons.md: active
- timeline.md: active
- summaries.md: active
- progress.md: active
- last.md: active
- graph.md: active
- vectors.md: active
- taxonomies.md: active
- standinginstructions.md: active

## Maintain Strategy

<!-- How the maintain phase dispatches agents — controls agent count per /pmm-save -->
- Strategy: single
<!-- Options: single (default) | tiered -->
<!-- single: all files updated in one agent dispatch — minimises token/message overhead -->
<!-- tiered: 3 concurrent agents grouped by file dependency — faster for large installations -->

## Protected Files

<!-- Files that are NEVER committed to git and NEVER read/written by the maintain agent -->
<!-- These are local-only — gitignored and excluded from all memory operations -->
- secrets.md: protected
<!-- secrets.md stores API keys, tokens, and credentials — gitignored, machine-local -->
- secrets_git: never
<!-- secrets_git options: never (default) | allow-with-warning -->
<!-- never: pre-commit hook blocks any commit containing memory/secrets.md -->
<!-- allow-with-warning: hook warns but does not block (irreversible if pushed to public repo) -->
- bootstrap_reminder: on
<!-- bootstrap_reminder options: on (default) | off -->
<!-- on: PMM will prompt to wire @memory/BOOTSTRAP.md into CLAUDE.md if not already done -->
<!-- off: suppress the reminder permanently (memory auto-load relies on manual skill triggers) -->
- bootstrap_wired: true
<!-- bootstrap_wired options: false (default) | true -->
<!-- true: @memory/BOOTSTRAP.md is confirmed wired in CLAUDE.md — Bootstrap Check skips file reads -->
