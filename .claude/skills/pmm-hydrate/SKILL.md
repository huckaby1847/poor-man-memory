---
name: pmm-hydrate
description: "Hydrate memory files from existing context. Populates empty or thin files by synthesizing content from all other memory files. Supports targeting specific files and force re-hydration. Use when the user runs /pmm-hydrate or asks to populate, hydrate, or refresh a memory file."
argument-hint: "<file | all> [force]"
---

# PMM Hydrate

Populate empty or thin memory files by synthesizing content from existing memory. Runs as a subagent to keep the main context clean.

**Arguments:** $ARGUMENTS

## Invocation

- `/pmm-hydrate` — show usage and list active files (no action taken)
- `/pmm-hydrate all` — hydrate all template-only active files
- `/pmm-hydrate taxonomies` — hydrate a specific file
- `/pmm-hydrate voices force` — re-synthesize even if file already has content
- `/pmm-hydrate all force` — re-synthesize all active files from scratch

## Behaviour

### Step 1 — Parse arguments

Parse `$ARGUMENTS`:
- **Empty** → show usage hint (Step 2), then stop
- `all` → target all template-only active files (or all active files if `force`)
- `<filename>` → target that file (accept with or without `.md` extension)
- `<filename> force` or `all force` → re-hydrate even if file has content

### Step 2 — If no arguments, show usage and stop

Read `memory/config.md` to get the list of active files. Then output:

```
Usage: /pmm-hydrate <file | all> [force]

Examples:
  /pmm-hydrate all              — hydrate all template-only files
  /pmm-hydrate taxonomies       — hydrate a specific file
  /pmm-hydrate voices force     — re-synthesize even if populated
  /pmm-hydrate all force        — re-synthesize all active files

Active files: <comma-separated list from config.md>
```

Do not proceed further.

### Step 3 — Read config and determine targets

Read `memory/config.md` to confirm active files. Skip deactivated files and always skip `secrets.md`.

If argument is `all`:
- Without `force`: scan each active file for template-only status. A file is template-only if — after stripping blank lines, `#` headings, HTML comments, and table header/separator rows — zero content lines remain. Collect template-only files as targets.
- With `force`: all active files are targets.

If argument is a specific filename:
- Confirm the file is active. If not active or not a valid memory file, report: "File `<name>.md` is not active or does not exist."
- Without `force`: check if it's template-only. If not, report: "`<name>.md` already has content. Use `force` to re-hydrate." and stop.
- With `force`: proceed regardless of content.

If `all` and no template-only files found (without force): report "No template-only files found. Use `force` to re-hydrate populated files."

### Step 4 — Hydrate target files

**If 2 or more target files:** dispatch a **single** `general-purpose` agent using the Phase 5 **batch hydration** prompt from `.claude/skills/poor-man-memory/SKILL.md`.

Substitute into the batch prompt:
- `<comma-separated list of filenames>` → all target filenames (e.g. `taxonomies.md, voices.md`)
- `<skill-base>` → the actual path to `.claude/skills/poor-man-memory`

**If exactly 1 target file:** dispatch a `general-purpose` agent using the Phase 5 **single-file hydration** prompt from `.claude/skills/poor-man-memory/SKILL.md`.

Substitute into the single-file prompt:
- `<new-file-name>` → the target filename (e.g. `taxonomies.md`)
- `<purpose>` → the file's purpose (look it up from BOOTSTRAP.md or the file's own header comment)
- `<skill-base>` → the actual path to `.claude/skills/poor-man-memory`

The agent uses `[system:hydrate]` attribution for all entries it writes.

After the agent returns, commit:
```bash
# Single file:
git add memory/<filename> && git commit -m "memory: hydrate <filename> from existing context"
# Multiple files:
git add memory/ && git commit -m "memory: hydrate <file1>, <file2>, ... from existing context"
```

### Step 5 — Report

After all targets are processed, report:
- Which files were hydrated
- A brief summary of what was inferred for each (the agent's return value)
- If nothing was hydrated, say so

### Step 6 — Bootstrap Check

**Run the Bootstrap Check** from `.claude/skills/poor-man-memory/SKILL.md` (`## Bootstrap Check` section).

## Notes

- The hydrate agent reads all existing memory files as context — the richer the existing memory, the better the hydration result
- `force` on a well-populated file may overwrite nuanced content with synthesized content — use with care
- This command does NOT run the maintain cycle — it only populates template-only or specified files
- After hydration, the next `/pmm-save` will treat hydrated files as populated and won't re-hydrate them
