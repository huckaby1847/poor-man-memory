# Progress

Current state, milestones, and what's next.
Updated whenever state changes meaningfully.

v1.3.1 released on GitHub. Repository is live at https://github.com/NominexHQ/poor-man-memory as a clone-and-go project. All 17 memory files implemented. 5 phases operational (Init, Session Start, Maintain, Recall, Hydrate). 7 skills built (poor-man-memory, pmm-settings, pmm-dump, pmm-viz, pmm-update, pmm-query, pmm-hydrate). Interactive D3.js visualization with time slider. Bootstrap Check reminder system prevents memory auto-load failures. System stable and undergoing dog-fooding.

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

## Next

- Fix SKILL.md documentation to reference corrected Bash permission rule syntax (remove old broken example)
- Implement notification framework for targeted /pmm-update announcements (for critical non-auto-apply fixes)
- Implement secrets.md feature with gitignore and maintain agent access control
- Add pre-PR checklist for GitHub account identity verification (prevent PR #12/#21/#?? repeat)
- Evaluate Phase 4 (Recall) vs /pmm-query interaction and user preferences
- Further dog-fooding across real projects with /pmm-query
- Community feedback on v1.3.2 release and feedback from wildcard fix distribution
- Extended use on nominex-pmm repository itself for self-referential memory iteration
