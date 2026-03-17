---
name: pmm-update
description: "Check for and apply updates to Poor Man's Memory system files from upstream. Compares local version to latest upstream, shows what changed, and applies updates to system files only — never touches memory/ or user data. Use when the user runs /pmm-update or asks to update PMM."
---

# PMM Update

Check the upstream Poor Man's Memory repository for updates and apply them safely. System files (skills, templates, artifacts) are updated; user data (memory/) is never touched.

## Invocation

- `/pmm-update` — check for updates and apply if available

## Behaviour

### Step 1 — Read local version

Read `pmm/version.json` in the project root.

- If the file exists, extract the `version` string and the `files.system` array.
- If the file does not exist, treat as version `0.0.0` (pre-versioning install). Use an empty `files.system` array.

### Step 2 — Clone upstream to temp

```bash
git clone --depth 1 https://github.com/NominexHQ/poor-man-memory.git /tmp/pmm-upstream-$$
```

If this fails (network error, auth issue), output: "Could not reach the upstream PMM repository. Check your network connection." Clean up and stop.

### Step 3 — Compare versions

Read `/tmp/pmm-upstream-$$/pmm/version.json`. Extract the upstream `version` string.

If local version equals upstream version:
- Output: `PMM is up to date (v{version})`
- Clean up temp directory
- Stop

If local version is behind: proceed.

### Step 4 — Build change report

Compare each file listed in the **upstream** `files.system` array:

1. **File exists locally AND differs from upstream** → mark as **M** (modified)
2. **File does not exist locally** → mark as **A** (added)
3. **File exists locally AND is identical** → mark as unchanged (skip)

Compare the **local** `files.system` array against the upstream one:
- Any file in the local list that is **NOT** in the upstream list → mark as **D** (deleted — upstream removed it)

For **merge files** (`.claude/settings.json`):
- Read both local and upstream versions
- Parse the `permissions.allow` arrays
- Identify entries in upstream that are missing locally
- Count the additions

### Step 5 — Show report and confirm

Present the change report to the user:

```
PMM Update Available: v{local} → v{upstream}
══════════════════════════════════════════════

Changed files:
  M  .claude/skills/pmm-viz/SKILL.md
  A  .claude/skills/pmm-update/SKILL.md
  A  pmm/version.json
  D  .claude/skills/old-removed-skill/SKILL.md

Merge (additive only):
  ~  .claude/settings.json  (+2 new permission entries)

Unchanged: 8 files (skipped)

Memory files: untouched (as always)
```

Then ask the user using `AskUserQuestion`:

> **Apply this update?**
> - **yes** — apply all changes
> - **no** — cancel, keep current version
> - **show diffs** — display file diffs before deciding

If "show diffs": display `diff -u` output for each M file and the full content of each A file, then ask again.

If "no": clean up temp directory, stop.

If "yes": proceed to Step 6.

### Step 6 — Apply updates via agent

Dispatch a `general-purpose` agent with this prompt:

> Apply PMM upstream updates. This is a WRITE task. Do NOT run any git commands.
>
> **Upstream source:** `/tmp/pmm-upstream-$$`
> **Project root:** `<project-root>`
>
> **System files to OVERWRITE** (copy from upstream, replacing local):
> [list each M and A file path]
>
> **System files to DELETE** (removed in upstream):
> [list each D file path]
>
> **Merge files** (additive only):
> - `.claude/settings.json`: Read both local and upstream. Parse the JSON `permissions.allow` arrays. Add any entries from upstream that are missing in local. Do NOT remove any existing entries. Preserve the user's custom permissions. Write back.
>
> **NEVER touch these files:**
> - Any file in `memory/`
> - `pmm/viz-cache.html`
> - `.claude/settings.local.json`
> - Any file not listed above
>
> **Instructions:**
> 1. For each OVERWRITE file: read the upstream version from `/tmp/pmm-upstream-$$/`, write it to the project path. Create parent directories if needed.
> 2. For each DELETE file: delete it. If the parent directory is now empty, remove it too.
> 3. For the merge file: read both, merge permissions additively, write back.
> 4. Return a summary: how many files overwritten, deleted, merged.

### Step 7 — Check for new memory file types

Read the upstream `references/templates.md` and the local one. If the upstream version has templates for memory files that don't exist in the local version:

1. Check if the user has an existing `memory/` directory (they've initialised PMM)
2. For each new memory file type:
   - Create the file from its template in `memory/`
   - Trigger Phase 5 (Hydrate) per the main skill — dispatch a `general-purpose` agent to populate the new file from existing memory context
   - Add the file to the active list in `memory/config.md`
3. If no `memory/` directory exists, skip this step (the files will be created at init time)

### Step 8 — Commit

```bash
git add .claude/skills/ pmm/ CLAUDE.md README.md .gitignore .claude/settings.json
git commit -m "pmm: update to v{new_version}"
```

Only add files that were actually changed. If new memory files were created and hydrated in Step 7:

```bash
git add memory/
git commit -m "memory: hydrate new files from PMM v{new_version} update"
```

### Step 9 — Clean up

```bash
rm -rf /tmp/pmm-upstream-$$
```

Delete the viz cache so it regenerates with the latest template:

```bash
rm -f pmm/viz-cache.html
```

### Step 10 — Report

Output a summary:

```
PMM updated to v{new_version}
  Updated: 3 system files
  Added: 2 new files
  Removed: 1 deprecated file
  Merged: settings.json (+2 permissions)
  New memory files: voices.md (hydrated from existing context)
```

## Notes

- **Never touch `memory/`** — except to add new file types introduced by the update (Step 7)
- **Merge, don't replace** `settings.json` — the user may have custom permissions
- **File moves/renames** manifest as DELETE of the old path + ADD of the new path. The `files.system` array in `version.json` makes this explicit.
- **Self-update**: This skill's own SKILL.md is in the system files list. It gets overwritten like any other. Takes effect on the next invocation.
- **Pre-versioning installs**: Users without `pmm/version.json` get treated as v0.0.0. Every system file is offered for update. After the update, they'll have `version.json` and future updates work normally.
- **Viz cache**: Always deleted after update so `/pmm-viz` regenerates with the latest template.
