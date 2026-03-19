# Poor Man's Memory

This project uses a structured memory system backed by markdown files and git.

## First Run

If the `memory/` directory doesn't exist, initialise the memory system:

```
init memory
```

This will prompt you for preferences (save cadence, verbosity, active files, etc.) and scaffold the memory files.

## Commands

- `/pmm-save` — Explicitly trigger a memory save
- `/pmm-hydrate <file|all> [force]` — Populate empty/thin memory files from existing context
- `/pmm-settings` — Change memory system configuration at any time
- `/pmm-dump` — ASCII memory dump (three levels: status, summary, detailed)
- `/pmm-viz` — Interactive D3.js memory graph (opens in browser)
- `/pmm-status` — Quick health dashboard (initialization, saves, file health)
- `/pmm-update` — Check for and apply PMM system updates from upstream
- `update memory` — Trigger a manual memory update
- `summarise memory` — Get a summary of what's in memory

## Recurring Saves

For automatic memory saves on an interval:

```
/loop 5m /pmm-save
```

This runs `/pmm-save` every 5 minutes, capturing session state without manual intervention.

## Memory

@memory/BOOTSTRAP.md

### Tier 1 — always loaded

Claude Code only resolves first-level @-imports. These files are imported here (not via
BOOTSTRAP.md) so they're guaranteed in context at session start and after /compact.

@memory/config.md
@memory/standinginstructions.md
@memory/last.md
@memory/progress.md
@memory/decisions.md
@memory/lessons.md
@memory/preferences.md
@memory/memory.md
@memory/summaries.md
@memory/voices.md
@memory/processes.md
@memory/timeline.md

### Tier 2 — on demand

Remaining memory files (graph, vectors, taxonomies, assets) live on disk.
Load via a haiku agent when needed — see BOOTSTRAP.md for trigger conditions.

## How It Works

Memory operations run in background agents — the main context window stays clean. Git commits after every update create an immutable audit trail. See `memory/config.md` for current settings.
