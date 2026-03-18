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
- Bootstrap Check utility prevents memory auto-load failures by detecting missing @memory/BOOTSTRAP.md wiring in CLAUDE.md (v1.3.1)
- All memory operations are dispatched via agents (subprocesses), not run in main context
- Agents edit files only — main context handles all git commits
- config.md controls phase behaviour: save cadence, commit behaviour, window sizes, verbosity, active file list
- GitHub repo: https://github.com/NominexHQ/poor-man-memory (v1.0 shipped 2026-03-16)
- Repository is structured as clone-and-go — not drop-in skill files
- `pmm/` directory at project root contains user-inspectable artifacts: D3.js library, HTML template, version manifest
- Interactive D3.js visualization: force-directed graph with type-colored nodes, search filters, time slider with git commits, cluster convex hulls

## Token Economics

- Session-start: ~10-18k tokens
- Maintain light: ~10k tokens
- Maintain major: ~21k tokens
- Per-session cost: ~$0.06-0.12 on Opus, ~5x cheaper on Sonnet
