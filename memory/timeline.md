# Timeline

Compressed chronological record of key events and milestones.
Append-only — entries go in chronological order.

## Format

**[Date]** — [What happened] [namespace:name?]
<!-- attribution: [user:name], [agent:name], or [system:process] — who originated this. Optional. -->

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
**2026-03-18** — Designed /pmm-query skill: explicit recall command with prose output, attribution/date/file/deep filters [agent:leith]
**2026-03-18** — Implemented /pmm-query with deep traversal (vector clusters, graph edges, taxonomy siblings) and dump mode [agent:leith]
**2026-03-18** — Updated SKILL.md and README.md with /pmm-query docs: query syntax, modifiers, output modes, examples [agent:leith]
**2026-03-18** — Tested /pmm-query live: git history fallback, multi-file prose traversal, deep mode synthesis [agent:leith]
**2026-03-18** — PR #15 merged: /pmm-query skill reviewed by raffi-ismail and merged to main (93f555a) [system:process]
**2026-03-18** — /pmm-hydrate skill created at .claude/skills/pmm-hydrate/SKILL.md — no-args usage hint, all flag for all template files, <file> targets single file, force re-synthesizes; dispatches Phase 5 agent per file with separate commits [agent:leith]
**2026-03-18** — /pmm-settings patched to dispatch Phase 5 Hydrate immediately after activating a deactivated file (was leaving activated files empty until next save) [agent:leith]
**2026-03-18** — Private email leak discovered in full git history: [redacted personal email] (15 commits) and [redacted personal email] (2 commits) exposed; remediated via git filter-branch with force-push to main and feature branches (second occurrence) [system:process]
**2026-03-18** — Git config fixed: local config set to 48171824+raffi-ismail@users.noreply.github.com for future commits; repo confirmed clean with no outstanding work [system:process]
**2026-03-18** — v1.3.1 released: Bootstrap Check reminder system added across all 6 PMM surfaces (init memory, /pmm-save, /pmm-hydrate, /pmm-update, /pmm-status, /pmm-query) [agent:leith]
**2026-03-18** — Reusable Bootstrap Check utility added to poor-man-memory/SKILL.md: detects missing @memory/BOOTSTRAP.md import in CLAUDE.md, prompts user with three options (fix now, remind later, never remind) [agent:leith]
**2026-03-18** — BOOTSTRAP.md self-reference (@memory/BOOTSTRAP.md in its own @-import list) removed from live file and template in references/templates.md [agent:leith]
**2026-03-18** — bootstrap_reminder config flag added to live memory/config.md and config.md template: on (default) enables prompts, off suppresses permanently [agent:leith]
**2026-03-18** — README.md updated: "Adding to an Existing Project" step 3 now includes note about wiring @memory/BOOTSTRAP.md into CLAUDE.md [agent:leith]
**2026-03-18** — PR #20 created by leith-dev: Bootstrap Check implementation, approved and merged by raffi-ismail [user:raffi]
**2026-03-18** — v1.3.1 GitHub release published at https://github.com/NominexHQ/poor-man-memory/releases/tag/v1.3.1 [system:process]
**2026-03-18** — User chose "Fix it now" at Bootstrap Check prompt after /pmm-save [user:raffi]
**2026-03-18** — BOOTSTRAP.md wired into CLAUDE.md under `## Memory` section; committed: "pmm: wire BOOTSTRAP.md into CLAUDE.md for auto-load" [system:process]
**2026-03-18** — Memory auto-load now active for nominex-pmm project; subsequent session starts will auto-recall @memory/BOOTSTRAP.md [system:process]
**2026-03-18** — Fixed Bash permission rule wildcard pattern in nominex-pmm and poor-man-memory-repo templates: `Bash(git commit -m 'memory:*')` → `Bash(git commit -m *)`. Quoted string with `*` inside triggered validation error on startup. [agent:leith]
**2026-03-18** — PR #21 created under wrong GitHub account (raffi-ismail); closed and recreated as PR #22 under leith-dev account. Approved and merged by raffi-ismail (second repeat of PR #12 account mix-up). [agent:leith]
**2026-03-18** — poor-man-memory-repo local clone pulled to latest: 8ed9425 → e0b35b5 (33 commits behind after merges resolved). [system:process]
**2026-03-18** — Version bumped to v1.3.2 in pmm/version.json; PR #23 created, reviewed, and merged; v1.3.2 GitHub release published. [system:process]
