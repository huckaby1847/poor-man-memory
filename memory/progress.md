# Progress

Current state, milestones, and what's next.
Updated whenever state changes meaningfully.

v1.4.0 released on GitHub with token/message overhead reduction. Repository is live at https://github.com/NominexHQ/poor-man-memory as a clone-and-go project. All 17 memory files implemented. 5 phases operational (Init, Session Start, Maintain, Recall, Hydrate). 7 skills built (poor-man-memory, pmm-settings, pmm-dump, pmm-viz, pmm-update, pmm-query, pmm-hydrate). Interactive D3.js visualization with time slider. Bootstrap Check reminder system prevents memory auto-load failures. Phase 3 Maintain supports configurable strategies: single (default, 1 agent) and tiered (opt-in, 3-agent tier dispatch). Phase 5 Hydrate uses batch mode to consolidate multiple file targets. Pre-check agent eliminated — template-only detection in main context. System stable and undergoing dog-fooding.

## Completed

- Memory system initialisation (13 files, git repo, first commit)
- Added vectors.md — semantic similarities, clusters, embedding registry
- Rewrote SKILL.md to use agent-based dispatch for all four phases (init, session start, maintain, recall)
- Added config.md — operational settings controlling save cadence, commit behaviour, window sizes, verbosity, active files
- Created /pmm-settings skill — re-presents preference prompts at any time
- Rewrote Phase 1 (init) with first-run preference prompt (5 interactive questions)
- Added summaries.md — periodic rollups with sliding window, two-tier temporal memory
- Changed timeline.md to sliding window (max 50 entries per config)
- Reorganised repo as clone-and-go project (skills in .claude/skills/, settings.json, CLAUDE.md, README.md)
- Updated README with installation instructions and Nominex branding
- Decided: agents edit files only, main context handles git
- Decided: config.md controls phase behaviour, not preferences.md
- Decided: repo is clone-and-go, not drop-in skill files
- Created GitHub repo and pushed v1.0
- Commit author switched to Leith identity for public-facing commits
- v1.0.0 release published
- Configurable maintain agent model (haiku default)
- PR workflow established (PRs #1-7)
- voices.md added — tone profiles and reasoning lenses
- Phase 5 "Hydrate" added for non-greenfield installs
- Standing instructions: no attribution in docs, proactive memory saves
- User voice captured in preferences.md
- Git history rewritten to remove private emails
- /pmm-viz added — ASCII visualization
- Major memory reconstruction from recovered conversation history
- Restructured /pmm-viz into three commands: /pmm-dump (ASCII), /pmm-viz (D3.js interactive), /pmm-status (dashboard)
- Created `pmm/` directory with D3.js library, HTML template, version manifest
- Implemented interactive D3.js force-directed graph with type-colored nodes, search, time slider, clusters
- Created /pmm-update command for manifest-based upstream synchronization
- Added argument-hint frontmatter and $ARGUMENTS variable for skill argument passing
- Implemented firstSeen/lastSeen temporal tracking per node/edge for D3.js time slider
- PR #10 merged to main
- Bootstrap Check cache (`bootstrap_wired` flag) eliminates CLAUDE.md reads post-wiring
- Pre-check agent removed — template-only detection moved to main context Read tool calls
- Batch hydration for Phase 5: single-file vs batch dispatch modes consolidate file I/O
- Configurable maintain strategy: `single` (default) and `tiered` (opt-in)
- v1.4.0 released with token/message overhead reduction
- PR #28 merged to main (6c65e96)

## In Progress

<!-- Nothing currently in progress -->

## Blocked

<!-- Nothing currently blocked -->

- Refactored /pmm-status, /pmm-dump, /pmm-update to subagent dispatch
- Added token burn estimates to /pmm-status and /pmm-dump
- Fixed Phase 5 auto-hydrate to detect and proactively populate template-only files
- Planned secrets.md feature (gitignored credentials storage)
- Feedback captured: enforce branch → PR → merge workflow, never push directly to main
- Designed and implemented /pmm-query skill for explicit recall with prose output, filtering, and deep traversal
- Updated SKILL.md and README.md with /pmm-query documentation and examples
- /pmm-hydrate skill created with multi-mode support (no-args hint, all, <file>, force)
- /pmm-settings patched to dispatch Phase 5 immediately on file activation
- Bootstrap Check reminder system implemented across all 6 PMM surfaces (init memory, /pmm-save, /pmm-hydrate, /pmm-update, /pmm-status, /pmm-query)
- Reusable Bootstrap Check utility added to SKILL.md: detects missing @memory/BOOTSTRAP.md in CLAUDE.md, prompts with three options (fix now, remind later, never remind)
- BOOTSTRAP.md self-reference removed from live file and template
- bootstrap_reminder config flag added (on/off control for prompts)
- README.md updated with CLAUDE.md wiring requirement note
- PR #20 merged: Bootstrap Check implementation reviewed and approved
- v1.3.1 released to GitHub

## In Progress

<!-- Nothing currently in progress -->

- Fixed Bash permission rule wildcard pattern (v1.3.2)
- Concurrent sub-agent tier-based dispatch for Phase 3 Maintain (v1.3.3)
- PR #25 and #27 merged, v1.3.3 released

## Completed (continued)

- Lazy session start (Phase 2) with configurable `session_start` mode (v1.5.0)
- Read-only model support via configurable `readonly_model` (haiku default) for all read-only agents (v1.5.0)
- Early-exit bug fix in pmm-save removed for correct false-negative handling (v1.5.0)
- pmm-settings Q11 + Q12 added for new readonly_model and session_start configs (v1.5.0)
- All read-only skill implementations updated to use readonly_model (pmm-query, pmm-dump, pmm-status, pmm-viz) (v1.5.0)
- v1.5.0 released to GitHub, PR #29 merged (2026-03-19)
- Context-First Recall (Phase 4) — Phase 4 Recall checks if session_start=lazy and bootstrap_wired=true, answers recall queries directly from in-context memory (already loaded via BOOTSTRAP.md) instead of dispatching agent; git history agent only as fallback behind recall_beyond_window permission gate (v1.6.0)
- Context-First Query (pmm-query) — all 5 query steps (parse, route, search, deep traversal, cross-reference) execute in main context when in lazy mode; git history fallback gated behind recall_beyond_window (v1.6.0)
- New config setting "Recall Beyond Window" with Mode: prompt default; controls whether sessions can fetch context beyond in-window memory (v1.6.0)
- pmm-settings Q13 added for recall_beyond_window (prompt/auto) configuration (v1.6.0)
- templates.md updated with new Recall Beyond Window section in config template (v1.6.0)
- pmm/version.json bumped 1.5.0 → 1.6.0 (v1.6.0)
- v1.6.0 Context-First Recall released (2026-03-19)
- Investigation: PreCompact and SessionEnd hooks discovered to be non-blocking in Claude Code; false "blocks compact" claims corrected across documentation (v1.7.1)
- Doc fix: Removed vestigial marker code (touch /tmp/pmm-compact-ready*) from pmm-save step 5b and Phase 3 post-commit block (v1.7.1)
- New explicit save trigger: "Before ending the session" (user says goodbye/closes conversation) added to BOOTSTRAP.md, SKILL.md, and templates (v1.7.1)
- v1.7.1 released to GitHub with documentation corrections and new session-exit trigger, PR #32 merged (2026-03-19)

## Completed (continued)

- Tier-aware auto-memory pointer format implemented (v1.8.0) — BOOTSTRAP.md, templates.md, SKILL.md updated with explicit Tier 1/Tier 2 distinction
- PR #33 created, reviewed, and merged via proper branch → PR → merge workflow
- v1.8.0 fix shipped via PR #33
- Tiered memory loading fix implemented (v1.9.0) — root cause: @-imports don't recurse; moved Tier 1 files to CLAUDE.md direct @-imports, kept Tier 2 on-demand via haiku agent
- CLAUDE.md, BOOTSTRAP.md, settings.json, templates.md, SKILL.md, pmm/version.json updated for v1.9.0
- v1.9.0 bump to version.json (category: merge)

## Next

- Fix SKILL.md documentation to reference corrected Bash permission rule syntax (remove old broken example)
- Implement notification framework for targeted /pmm-update announcements (for critical non-auto-apply fixes)
- Add pre-PR checklist for GitHub account identity verification (prevent repeat)
- Evaluate Phase 4 (Recall) vs /pmm-query interaction and user preferences
- Further dog-fooding across real projects with /pmm-query
- Community feedback on v1.9.0 release
- Extended use on nominex-pmm repository itself for self-referential memory iteration
- Monitor readonly_model performance with real sessions across projects
- Consider expanded model options (e.g., claude-3.5-sonnet for higher-fidelity recalls)
- Add `gh auth switch --user leith-dev` as mandatory step before `gh pr create` in standinginstructions.md (account mix-up 4th repeat)
