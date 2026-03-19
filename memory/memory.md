# Memory

Long-term facts about this project and context.
Updated when new durable facts are established.

## Project

Poor Man's Memory — a lightweight, git-backed structured memory system for Claude Code. No infrastructure required. Everything is markdown files in a folder, committed to git for audit history. The skill lives in `.claude/skills/poor-man-memory/`.

## Context

The project being worked on IS the poor-man-memory skill itself. The user is actively improving the skill — adding files, rewriting dispatch logic, refining reference docs. This is self-referential: the memory system is recording changes to itself. The project directory was renamed from "Poor Man's Memory" to "nominex-pmm" during development.

## Key Facts

- PMM is a 17-file markdown memory system backed by git
- 5 operational phases: Init, Session Start, Maintain, Recall, Hydrate
- 7 skills: poor-man-memory (main), pmm-settings (config), pmm-dump (ASCII viz), pmm-viz (interactive D3.js), pmm-update (upstream sync), pmm-query (explicit recall), pmm-hydrate (explicit hydration)
- 4 reference files: graph-syntax.md, vector-syntax.md, voice-syntax.md, templates.md
- Bootstrap Check utility prevents memory auto-load failures by detecting missing @memory/BOOTSTRAP.md wiring in CLAUDE.md (v1.3.1); cache flag `bootstrap_wired` eliminates file reads once wired (v1.4.0)
- Claude Code's PreCompact and SessionEnd hooks are observational/non-blocking (v1.7.1) — compact/exit saves rely on soft instruction from BOOTSTRAP.md being honored by Claude, not enforced hooks
- All memory operations are dispatched via agents (subprocesses), not run in main context
- Agents edit files only — main context handles all git commits
- config.md controls phase behaviour: save cadence, commit behaviour, window sizes, verbosity, active file list, maintain strategy (single or tiered), readonly_model (haiku default for read-only agents), session_start mode (lazy default)
- GitHub repo: https://github.com/NominexHQ/poor-man-memory (v1.0 shipped 2026-03-16, v1.9.0 shipped 2026-03-19 with tiered memory loading fix)
- Repository is structured as clone-and-go — not drop-in skill files
- `pmm/` directory at project root contains user-inspectable artifacts: D3.js library, HTML template, version manifest
- Interactive D3.js visualization: force-directed graph with type-colored nodes, search filters, time slider with git commits, cluster convex hulls
- Tiered memory loading (v1.9.0): @-imports don't recurse in Claude Code; solution moves 13 Tier 1 core files to direct CLAUDE.md @-imports (always in-context, no agent needed) and keeps 4 Tier 2 relational files (graph.md, vectors.md, taxonomies.md) as on-demand haiku agent reads
- Phase 2 (Session Start) uses configurable `session_start` mode: lazy (default, skips Phase 2 when bootstrap_wired: true, saves ~33k tokens) and eager (always dispatch, pre-v1.5.0 behaviour)
- All read-only agent dispatches (Phase 2, Phase 4, pmm-query, pmm-dump, pmm-status, pmm-viz) use configurable `readonly_model` (haiku default, ~95% cheaper than Opus, ~73% cheaper than Sonnet)
- Phase 3 Maintain supports configurable dispatch strategies: single (default, 1 agent, minimal overhead) and tiered (opt-in, 3-agent concurrent, faster for large installs)
- Phase 5 Hydrate uses batch dispatch: single-file mode (1 agent per target) and batch mode (1 agent for multiple targets, consolidates I/O)
- Template-only file detection moved from dedicated agent to main context Read calls (v1.4.0 optimization)
- Early-exit bug fix in pmm-save removed false-negatives when memory not loaded at session start; now always dispatches agent (no-op haiku dispatch when no changes, ~$0.006 cost)
- Explicit save triggers: /pmm-save command, /pmm-query executed, /pmm-hydrate executed, config change via /pmm-settings, new decision/entity/process established, before ending the session (v1.7.1)
- Breaking change in v1.9.0: CLAUDE.md moved from system to merge category in version.json, requires manual update for existing installs
- Tier-aware pointer format (v1.8.0): distinguishes Tier 1 (in-context, no Read) vs Tier 2 (on-disk, Read required) to eliminate unnecessary pointer-triggered reads

## Token Economics

- Session-start: ~10-18k tokens (lazy mode with bootstrap_wired: true, ~33k save vs eager)
- Maintain light: ~10k tokens
- Maintain major: ~21k tokens
- Overall cost reduction v1.4.0-v1.5.0: 73-90% vs pre-v1.4.0 (via readonly_model haiku, lazy session-start, batch hydration, single maintain strategy)
- Per-session cost: ~$0.06-0.12 on Opus, ~5x cheaper on Sonnet
