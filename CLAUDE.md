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

## How It Works

Memory operations run in background agents — the main context window stays clean. Git commits after every update create an immutable audit trail. See `memory/config.md` for current settings.
