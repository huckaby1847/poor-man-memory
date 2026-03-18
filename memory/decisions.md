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

**2026-03-16 — Use agents (subprocesses) for all memory operations**
Context: Main context window was getting polluted with file I/O and git ops during memory phases. Dispatching agents keeps the main window clean — agents do the heavy lifting and return concise results.
Ratified by: user
