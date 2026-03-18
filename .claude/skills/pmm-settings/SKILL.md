---
name: pmm-settings
description: "Change Poor Man's Memory configuration. Re-presents preference prompts for save cadence, commit behaviour, push behaviour, sliding window size, verbosity, repository visibility, maintain agent model, secrets_git, and active files. Use when the user runs /pmm-settings or asks to change memory system settings."
---

# PMM Settings

Reconfigure the Poor Man's Memory system. This skill presents the same preference prompts used during first-run initialisation, pre-filled with current values.

## When Triggered

User runs `/pmm-settings` or asks to change memory configuration.

## Flow

### Step 1 — Read current config

Read `memory/config.md` and display the current settings to the user as a summary:

> **Current PMM settings:**
> - Save cadence: [current]
> - Commit behaviour: [current]
> - Auto-push: [current]
> - Window size: [current preset or custom]
> - Verbosity: [current]
> - Repository visibility: [current]
> - Maintain agent model: [current]
> - Maintain strategy: [current]
> - Secrets in git: [current]
> - Active files: [count] of 15 active
> - Deactivated: [list, or "none"]

### Step 2 — Present preference prompts

Use `AskUserQuestion` to present the same questions from Phase 1 of the main skill, pre-filled with current values. The user can change any or all options.

**Q1: Save cadence** — How often should memory be updated?
- Every major milestone (default) — updates at decisions, milestones, session breaks
- Every N messages — specify a number (e.g. every 5 messages)
- On explicit request only — only when you ask

*Note: For fine-grained control, use `/loop` to run a save prompt on a recurring interval.*

**Q2: Commit behaviour** — When should changes be committed to git?
- Auto-commit after every update batch (default)
- Batch commits at session end only
- Manual commits only

**Q3: Auto-push** — Should memory commits be automatically pushed to the remote?
- Off (default) — commits stay local until you push manually
- On — git push runs after every memory commit (failures reported, not swallowed)

**Q4: Sliding window size** — How many entries to keep before trimming?
- Light (30 timeline / 5 summaries)
- Moderate (50 / 10, default)
- Heavy (100 / 20)
- Unlimited (no trimming)

**Q5: Verbosity** — How should memory updates be communicated?
- Silent — agent status indicator only
- Summary (default) — one-line confirmation
- Verbose — full detail

**Q6: Repository visibility** — Is this repository public or private?
- Public (default) — maintain agent avoids personal emails, uses handles over full names, summarises sensitive decisions
- Private — no PII restrictions, full fidelity in all files

**Q7: Maintain agent model** — Which model should handle memory updates?
- Haiku (default) — fastest and cheapest, good for mechanical file edits
- Sonnet — balanced, better at nuanced updates
- Opus — most capable, highest cost

*Note: Session-start and recall agents always use your current model.*

**Q8: Maintain strategy** — How should memory saves dispatch agents?
- Single (default) — all files updated in one agent dispatch per save (minimises token/message overhead, budget-friendly)
- Tiered — 3 concurrent agents grouped by file dependency (faster for large installations with many active files)

*Explain: Single mode saves 2 agent dispatches per /pmm-save. Tiered mode is faster if you have a large memory installation and need parallel tier updates — but costs 3x the agent dispatches.*

**Q9: Secrets in git** — Should `memory/secrets.md` be committed to git?
- Never (default) — pre-commit hook blocks any commit containing secrets.md
- Allow with warning — hook warns but does not block. **Only use this if you understand the implications: secrets.md contents will be in git history and permanently exposed if pushed to a public remote.**

**Q10: Active files** — Which memory files to activate? (multi-select, config.md and BOOTSTRAP.md always active)
- memory.md, assets.md, decisions.md, processes.md, preferences.md, voices.md, lessons.md, timeline.md, summaries.md, progress.md, last.md, graph.md, vectors.md, taxonomies.md, standinginstructions.md

### Step 3 — Write updated config

Update `memory/config.md` with the new values. Preserve the file format from the template.

If active files changed:
- Update `memory/BOOTSTRAP.md` to list only the active files in the load order
- If files were deactivated, do NOT delete them — just remove them from BOOTSTRAP.md
- If files were activated that don't exist yet, create them from templates
- **For each newly activated file**, dispatch Phase 5 (Hydrate) using the prompt from `.claude/skills/poor-man-memory/SKILL.md`. This ensures activated files start with synthesized content from existing memory, not empty templates. Commit hydrated files separately: `git add memory/<file> && git commit -m "memory: hydrate <file> from existing context"`

### Step 4 — Commit

```bash
git add memory/config.md memory/BOOTSTRAP.md && git commit -m "memory: update PMM configuration"
```

Confirm to the user: settings updated and saved.
