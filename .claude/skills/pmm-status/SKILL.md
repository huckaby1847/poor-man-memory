---
name: pmm-status
description: "Quick PMM health dashboard. Shows initialization state, last save time, recent commits, file health, and warnings. Use when the user runs /pmm-status or asks if memory is saving, working, or healthy."
---

# PMM Status

Quick health dashboard for Poor Man's Memory. Pure terminal output — no browser, no agents.

## Invocation

- `/pmm-status` — show full status dashboard

## Behaviour

### Step 1 — Check initialization

Check if `memory/` directory exists and count files:
```bash
ls memory/*.md 2>/dev/null | wc -l
```

If no memory directory exists, output:
```
PMM Status
══════════

Initialized: No
Run "init memory" to get started.
```
And stop.

### Step 2 — Read config

Read `memory/config.md` to get:
- Save cadence
- Commit behaviour
- Maintain agent model

### Step 3 — Get last save time

```bash
git log -1 --format="%ar|%ai" -- memory/
```

### Step 4 — Get recent memory commits

```bash
git log --oneline -5 -- memory/
```

### Step 5 — Build file health table

For each `.md` file in `memory/`:

1. Get last modified time: `git log -1 --format="%ar" -- memory/<file>`
2. Count lines: `wc -l < memory/<file>`
3. Determine status:
   - **Template-only detection:** Read the file. Strip blank lines, lines starting with `#`, lines that are only `---`, HTML comments (`<!-- ... -->`), table header rows (`| --- |`), and introductory/description text (first paragraph after a heading that describes the file's purpose). If 0 content lines remain → `⚠ template-only`.
   - Otherwise → `✓ populated`

Sort by last modified (most recent first).

### Step 6 — Generate warnings

Check for:
- **Template-only active files:** Any active file (per config.md) that is still template-only
- **Stale files:** Any file not modified in >7 days (only warn if project has commits in the last 7 days)
- **Stale last.md:** `last.md` not updated in the current session (last modified >2 hours ago)
- **Large files:** Any file >200 lines (suggest trimming)

### Step 7 — Output

Render the dashboard:

```
PMM Status
══════════

Initialized: Yes (17 files)
Last save:   2 minutes ago (2026-03-17 16:30:00)
Save cadence: every-milestone
Commit mode:  auto-commit

Recent Saves
  e6714a5  memory: major reconstruction from recovered transcripts
  495ae34  memory: update session 2026-03-17
  e6714a5  feat: add /pmm-viz
  025e161  memory: enrich user voice
  94bae9e  feat: capture user voice

Files                        Last Modified    Lines  Status
  config.md                  2 min ago          58   ✓ populated
  BOOTSTRAP.md               3 hr ago          130   ✓ populated
  memory.md                  3 hr ago           42   ✓ populated
  taxonomies.md              3 hr ago           12   ⚠ template-only
  ...

Total: 847 lines across 17 files

Warnings
  ⚠ taxonomies.md is still template-only
  ⚠ summaries.md has not been updated in 3 days
```

### Notes

- This is a prompt-only skill — Claude reads files and git log, then renders the output. No agents, no subprocesses.
- All times should be human-readable ("2 min ago", "3 hr ago").
- If there are no warnings, show "No warnings" instead of the Warnings section.
- Keep the output compact and scannable.
