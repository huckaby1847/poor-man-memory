# Timeline

Compressed chronological record of key events and milestones.
Append-only — entries go in chronological order.

## Format

**[Date]** — [What happened]

---

**2026-03-16** — Memory system initialised with 13 template files
**2026-03-16** — Added vectors.md as 14th memory file — semantic similarities, clusters, embedding registry
**2026-03-16** — Rewrote SKILL.md to agent-based dispatch — all memory ops run as subprocesses, main context stays clean
**2026-03-16** — Discovered agents may lack Bash permissions — added fallback note to SKILL.md: if agent can't commit, main context handles it
**2026-03-16** — Architecture change: agents edit files only, main context handles all git commits
**2026-03-16** — Added config.md as memory file — stores PMM configuration (save cadence, commit behaviour, window sizes, verbosity, active files)
**2026-03-16** — Created /pmm-settings skill at .claude/skills/pmm-settings/ — re-presents preference prompts at any time
**2026-03-16** — Added summaries.md — periodic rollups with sliding window (max 10), two-tier temporal memory with timeline.md
**2026-03-16** — Changed timeline.md to sliding window (max 50 per config)
**2026-03-16** — Rewrote Phase 1 (init) with first-run preference prompt — 6 interactive questions before scaffolding
**2026-03-16** — Reorganised poor-man-memory-repo/ as clone-and-go project: moved skills to .claude/skills/, added settings.json, CLAUDE.md, README.md
**2026-03-16** — Updated README with Nominex branding, installation docs
**2026-03-16** — Created GitHub repo at https://github.com/NominexHQ/poor-man-memory and pushed v1.0
**2026-03-16** — Commit author switched to Leith for public-facing identity
**2026-03-16** — v1.0.0 release published
**2026-03-16** — Configurable maintain agent model added
**2026-03-16** — PR workflow established (PRs #1-7)
**2026-03-16** — voices.md added — tone profiles and reasoning lenses
**2026-03-16** — Phase 5 "Hydrate" added for non-greenfield installs
**2026-03-17** — Standing instructions: no attribution in docs, proactive memory saves
**2026-03-17** — User voice captured in preferences.md
**2026-03-17** — Git history rewritten to remove private emails
**2026-03-17** — /pmm-viz added — ASCII visualization for memory state
**2026-03-17** — Restructured /pmm-viz: /pmm-dump (ASCII, 3 levels), /pmm-viz (D3.js graph), /pmm-status (dashboard)
**2026-03-17** — Implemented interactive D3.js force-directed graph with type colors, search, filters, time slider, convex hulls
**2026-03-17** — Created `pmm/` directory with D3.js v7.9.0, HTML template, version.json manifest
**2026-03-17** — Created /pmm-update command for manifest-based upstream sync
**2026-03-17** — Added frontmatter `argument-hint` and `$ARGUMENTS` variable for skill argument passing
**2026-03-17** — Implemented firstSeen/lastSeen timestamps per node/edge for D3.js time slider
**2026-03-17** — PR #10 merged to main — all new viz and update commands shipped
**2026-03-18** — Refactored /pmm-status, /pmm-dump, /pmm-update to dispatch subagents for clean main context
**2026-03-18** — Added token burn estimates to /pmm-status and /pmm-dump (chars/4 read, diff lines × 20 / 4 write)
**2026-03-18** — Fixed Phase 5 auto-hydrate to detect and populate template-only files proactively
**2026-03-18** — Planned secrets.md feature: gitignored local-only storage for API keys, tokens, credentials
