# Decisions

Committed decisions. Append-only — never delete or modify past entries.
Each entry is ratified and should be treated as ground truth unless explicitly reversed.

## Format

**[Date] — [Decision]** [namespace:name?]
<!-- attribution: [user:name], [agent:name], or [system:process] — who originated this. Optional. -->
Context: why this was decided
Ratified by: [user / consensus / default]

---

**2026-03-17 — Interactive D3.js viz as primary memory visualization tool**
Context: ASCII /pmm-viz was useful but limited. Restructured into three commands with D3.js force-directed graph as the main viz (runs as subagent, opens in browser), /pmm-dump for terminal ASCII, /pmm-status for health checks. Type-colored nodes, search, filters, time slider.
Ratified by: user

**2026-03-17 — Artifacts in visible `pmm/` directory, not hidden `.claude/`**
Context: D3.js library, HTML template, version manifest should be inspectable by users. Placed at project root `pmm/` rather than hidden `.claude/skills/poor-man-memory/` for transparency and ease of audit.
Ratified by: user

**2026-03-17 — Manifest-based update system (/pmm-update) for upstream sync**
Context: Decided against git merge for system file updates — too risky. Instead: clone-to-temp, manifest diff, file-by-file apply with user confirmation. Handles renames as delete+add.
Ratified by: user

**2026-03-17 — Frontmatter `argument-hint` and `$ARGUMENTS` for skill argument passing**
Context: Skills needed a standard way to declare and receive command-line arguments. Added `argument-hint` in YAML frontmatter and `$ARGUMENTS` variable available at runtime.
Ratified by: user

**2026-03-17 — firstSeen/lastSeen per node/edge, not full snapshots, for time slider**
Context: D3.js time slider tracks temporal evolution of graph. Each node/edge records firstSeen and lastSeen timestamps instead of per-commit snapshots. More efficient, sufficient granularity.
Ratified by: user

**2026-03-17 — Phase 5 "Hydrate" for non-greenfield installs**
Context: When PMM is installed in an existing project (not a fresh clone), memory files need to be seeded from existing context. Phase 5 handles this — new files are populated from whatever memory already exists.
Ratified by: user

**2026-03-16 — User voice captured in preferences.md, not a separate file**
Context: Considered a dedicated user-voice file but decided preferences.md is the right home. Keeps identity info co-located with other user preferences.
Ratified by: user

**2026-03-16 — Maintain agent defaults to haiku model**
Context: Maintain phase work is mechanical — read file, append entry, replace section. Doesn't need opus-level reasoning. Haiku is ~10x cheaper. Configurable via config.md if needed.
Ratified by: user

**2026-03-16 — Sliding windows with git history as backing store**
Context: Timeline and summaries use fixed-size sliding windows (configurable in config.md). When entries are trimmed, they're not lost — git history preserves the full record. Bounded memory with full audit trail.
Ratified by: user

**2026-03-16 — Two-tier temporal memory: timeline (fine-grained) + summaries (compressed rollups)**
Context: timeline.md captures individual events. summaries.md compresses batches into narrative rollups. Two resolutions of the same temporal data — high-fidelity and compressed.
Ratified by: user

**2026-03-16 — No transcript.md — last.md covers recent context**
Context: Considered adding transcript.md for conversation history. User said "bin it" — last.md already serves as the recent context window. No need for a second file covering similar ground.
Ratified by: user

**2026-03-16 — Repository structured as clone-and-go, not drop-in skill files**
Context: poor-man-memory-repo/ is a complete project directory with .claude/, CLAUDE.md, settings.json, and README. Users clone and start using — no manual file shuffling required.
Ratified by: user

**2026-03-16 — config.md controls all phase behaviour (not preferences.md)**
Context: preferences.md stores user style/workflow preferences. config.md is the operational control file — save cadence, commit behaviour, window sizes, verbosity, active file list. All phases read config.md first.
Ratified by: user

**2026-03-16 — Agents edit files only, main context handles all git commits**
Context: Agent subprocesses write memory file changes but never run git commands. The main context is responsible for staging, committing, and pushing. This avoids permission issues and keeps git history clean.
Ratified by: user

**2026-03-16 — vectors.md added as semantic companion to graph.md**
Context: graph.md captures explicit typed edges but can't represent implicit weighted relationships. vectors.md fills that gap — semantic similarities with scores, concept clusters, and embedding provenance tracking.
Ratified by: user

**2026-03-18 — Subagent dispatch for /pmm-status, /pmm-dump, /pmm-update (complete refactor)**
Context: Refactored all three commands to follow the pattern /pmm-viz already uses. All heavy lifting (file reads, git commands, rendering) runs in a general-purpose subagent; main context outputs the result verbatim. Keeps main context clean.
Ratified by: consensus

**2026-03-18 — Token burn estimates in /pmm-status and /pmm-dump outputs**
Context: Memory saves consume tokens. /pmm-status and /pmm-dump now estimate token cost per save cycle: read tokens = file size in chars / 4, write tokens = diff lines × 20 / 4. Helps users understand cost of their save cadence.
Ratified by: consensus

**2026-03-18 — secrets.md for gitignored API keys and credentials**
Context: PMM needs a place to store sensitive data (API keys, tokens, auth credentials) that is never committed to git. Planned feature: memory/secrets.md is gitignored, local-only, not readable/writable by maintain agent. Pattern: .gitignore rules + git reset in commit step.
Ratified by: consensus

**2026-03-18 — /pmm-query: explicit recall command with prose output by default** [agent:leith]
Context: Designed separate explicit recall skill distinct from Phase 4 Recall. Supports free-text search, attribution filter (by namespace:name), date filters (since/before), file scope (in <file>), deep traversal mode (expands via vectors/graph/taxonomies), dump modifier (verbatim entries). Default output is synthesized narrative prose with inline source citations and Sources footer; dump mode shows verbatim entries grouped by file.
Ratified by: consensus

**2026-03-18 — Deep traversal expands results via vector clusters, graph edges, and taxonomy siblings** [agent:leith]
Context: When deep mode specified in /pmm-query, agent: (a) finds vector cluster membership + similarity pairs ≥0.6 from vectors.md, (b) traverses one-hop edges from graph.md, (c) broadens via taxonomy siblings from taxonomies.md. Results tagged with provenance [via vectors], [via graph], [via taxonomy]. Enables multi-file cross-reference discovery.
Ratified by: consensus

**2026-03-18 — /pmm-settings now triggers immediate Phase 5 Hydrate on file activation**
Context: Previously, when a deactivated file was re-activated via /pmm-settings, it would remain empty until the next memory save cycle. Closing this gap: activation now dispatches Phase 5 immediately, populating the file from existing context before returning to the user.
Ratified by: consensus

**2026-03-18 — /pmm-hydrate no-args shows usage hint, not default action**
Context: /pmm-hydrate is a multi-mode skill supporting: (1) no args → show usage hint and available modes; (2) all → hydrate all template-only files; (3) <file> → target one file; (4) force → re-synthesize even if already populated. Default behavior is informational, not destructive. Users must opt-in explicitly.
Ratified by: consensus

**2026-03-18 — Bootstrap Check reminder system across all PMM surfaces** [agent:leith]
Context: Memory auto-load at session start depends on @memory/BOOTSTRAP.md being imported in CLAUDE.md. If that wiring is missing, the user's memory never loads despite PMM being initialized. Implemented reusable Bootstrap Check utility that detects missing import and prompts user with three options: (1) Fix it now (auto-wires CLAUDE.md + commits), (2) Remind me next time, (3) Never remind me (sets bootstrap_reminder: off in config). Check runs on all 6 surfaces: init memory, /pmm-save, /pmm-hydrate, /pmm-update, /pmm-status, /pmm-query. Ensures users are aware of and can easily fix this critical wiring step.
Ratified by: consensus

**2026-03-18 — Wire BOOTSTRAP.md into CLAUDE.md for automatic memory auto-load at session start** [user:raffi]
Context: Bootstrap Check system prompts users to wire @memory/BOOTSTRAP.md into CLAUDE.md under a `## Memory` section. This import is critical — without it, memory never auto-loads despite PMM being initialized. User selected "Fix it now", which auto-wired CLAUDE.md and committed the change (commit: pmm: wire BOOTSTRAP.md into CLAUDE.md for auto-load). Memory auto-load now active for this project.
Ratified by: user

**2026-03-16 — Use agents (subprocesses) for all memory operations**
Context: Main context window was getting polluted with file I/O and git ops during memory phases. Dispatching agents keeps the main window clean — agents do the heavy lifting and return concise results.
Ratified by: user

**2026-03-18 — Wildcards in permission rules must NOT be inside quoted strings** [agent:leith]
Context: Permission rule `Bash(git commit -m 'memory:*')` failed validation because `*` was quoted. Correct form: `Bash(git commit -m *)`. Validation error was silent, rule skipped at startup. Applied fix to both active project .claude/settings.json and poor-man-memory-repo template.
Ratified by: consensus

**2026-03-18 — Retain settings.json in merge category for /pmm-update (not auto-apply)** [agent:leith]
Context: Bash wildcard fix is in .claude/settings.json, which has category `merge` in version.json. This prevents /pmm-update from auto-applying it to existing installs (risky to auto-merge settings files). Fix will require manual update or user confirmation during /pmm-update. Trade-off accepted: safety (no surprise setting changes) over convenience (auto-apply fix).
Ratified by: consensus

**2026-03-18 — Configurable maintain strategy: single (default) or tiered** [user:raffi]
Context: v1.4.0 replaces fixed tier-based dispatch with configurable `Strategy` in config.md. Default is `single` (1 agent, all files, minimal overhead — correct for typical use). Optional `tiered` mode (3-agent tier dispatch, faster for large installations but higher per-save cost). Q8 in /pmm-settings lets users choose at any time.
Ratified by: user

**2026-03-18 — Batch hydration for Phase 5 with smart dispatch**
Context: Phase 5 Hydrate now detects single-file (1 target) vs batch (2+ targets). Single-file dispatches 1 agent per target with separate commit per file. Batch mode dispatches ONE agent reading all populated files once, writing all template-only targets in single commit. Saves up to 14 agent dispatches and consolidates file I/O. Both /pmm-save and /pmm-hydrate updated to use batch mode when possible.
Ratified by: consensus

**2026-03-18 — Eliminate dedicated pre-check agent in Phase 5**
Context: Template-only detection (checking if file is empty structure vs fully populated) moved from a dedicated read-only agent to main context Read tool calls. Main context reads each active file directly, strips blanks/headings/comments, counts content lines. Saves 1 agent dispatch per /pmm-save. Trade-off: main context stays cleaner but pre-check logic lives in SKILL.md rather than isolated agent.
Ratified by: consensus

**2026-03-18 — Bootstrap Check cache via `bootstrap_wired` flag**
Context: Bootstrap Check was re-reading CLAUDE.md on every invocation across all 6 PMM skills to detect if @memory/BOOTSTRAP.md was wired. Once wired is confirmed (during step 2 wiring or after "Fix it now"), set `bootstrap_wired: true` in config.md. Bootstrap Check then skips file reads entirely. New installs default `bootstrap_wired: false` in templates. Eliminates repeated CLAUDE.md read once wired.
Ratified by: consensus

**2026-03-19 — Lazy session start (Phase 2) when bootstrap_wired: true** [user:raffi]
Context: Phase 2 agent (session-start recall) is expensive (~10-18k tokens, reads all 15 files). When @memory/BOOTSTRAP.md is wired into CLAUDE.md, memory files auto-load via direct @-imports in CLAUDE.md without needing an explicit recall agent. New config setting `session_start: lazy` (default) skips Phase 2 entirely in this case, saving ~33k tokens per session. Option `eager` preserves pre-v1.5.0 behaviour (always dispatch Phase 2 agent). Falls back to eager if `bootstrap_wired: false`.
Ratified by: user

**2026-03-19 — Readonly model (haiku default) for all read-only agent dispatches** [user:raffi]
Context: Session-start Phase 2, recall Phase 4, and all read-only skills (pmm-query, pmm-dump, pmm-status, pmm-viz) do not need full reasoning — they read files and synthesize summaries. Configurable `readonly_model` (default: haiku) forces haiku for these agents instead of inheriting the parent model. ~95% cheaper than Opus, ~73% cheaper than Sonnet for the same tasks. Options: haiku (default) | sonnet | opus | inherit (pre-v1.5.0 behaviour using parent model). Applied to config.md, SKILL.md, pmm-save/SKILL.md, and all read-only skill implementations (pmm-query, pmm-dump, pmm-status, pmm-viz).
Ratified by: user

**2026-03-19 — Context-first recall pattern for Phase 4 and pmm-query** [user:raffi]
Context: When `session_start=lazy` and `bootstrap_wired=true`, memory files are already loaded in-context via @memory/BOOTSTRAP.md imports. Phase 4 Recall and pmm-query should exploit this: answer queries directly from in-memory files without dispatching an agent. Only fall back to agent for git history when answer not in context, and gate that behind user permission `recall_beyond_window` (prompt or auto mode). Reduces latency and token cost for in-window recalls by 50%+.
Ratified by: user

**2026-03-19 — v1.6.0 context-first recall pattern (Phase 4 & pmm-query)** [user:raffi]
Context: When `session_start=lazy` and `bootstrap_wired=true`, memory files are already loaded in-context via @memory/BOOTSTRAP.md imports. Phase 4 Recall and /pmm-query should exploit this by answering queries directly from in-memory files without dispatching an agent. Only fall back to agent for git history when answer not in context, gated behind user permission `recall_beyond_window` (prompt or auto mode). Reduces latency and token cost for in-window recalls by 50%+. Eager mode fallback unchanged.
Ratified by: user

**2026-03-18 — Tier-based concurrent sub-agents for Phase 3 Maintain** [user:raffi]
Context: Single maintain agent handling all 15 files sequentially is slow. Replacing with a three-tier concurrent dispatch: Tier 1 (event files: last.md, timeline.md, summaries.md, progress.md) and Tier 2 (content files: decisions.md, lessons.md, preferences.md, memory.md, processes.md, voices.md, assets.md, standinginstructions.md) run in parallel. Tier 3 (relational files: graph.md, vectors.md, taxonomies.md) runs after both complete, reading updated file state from Tier 1+2. Template-only pre-check also moved to a single concurrent read-only agent rather than sequential per-file checks.
Ratified by: user
