---
name: pmm-save
description: "Trigger a PMM memory save. Dispatches the maintain agent to capture current session state into memory files and commits. Use when the user runs /pmm-save or wants to explicitly save memory. Works with /loop for recurring saves (e.g. /loop 5m /pmm-save)."
---

# PMM Save

Lightweight trigger for Phase 3 (Maintain) of Poor Man's Memory. Captures current session state into memory files.

## Behaviour

1. Read `memory/config.md` to get the maintain agent model (default: `haiku`) and active files list
2. **Template-only check:** Dispatch a single read-only agent to check all active files concurrently for template-only status (strip blank lines, headings, comments, table headers — if 0 content lines remain, it's template-only). If ANY active files are template-only AND at least 3 other files are populated, dispatch Phase 5 (Hydrate) for each template-only file BEFORE the maintain cycle. Use the Phase 5 prompt from `.claude/skills/poor-man-memory/SKILL.md`. Commit hydrated files separately: `git add memory/ && git commit -m "memory: hydrate <file> from existing context"`
3. Build a "What changed" summary by reviewing the current conversation since the last save — identify decisions, facts, preferences, milestones, lessons, or any other notable events
4. Dispatch the maintain agents using the Phase 3 tier-based dispatch from the main `poor-man-memory` skill (`.claude/skills/poor-man-memory/SKILL.md`, Phase 3 — Maintain section). Tier 1 and Tier 2 run in parallel; Tier 3 runs after both complete.
5. After the agent returns, commit. Read `memory/config.md` for the `Auto-push` setting:
   ```bash
   # Always:
   git add memory/ && git reset HEAD memory/secrets.md 2>/dev/null; git commit -m "memory: <brief description>"

   # Only if Auto-push is "on" in config.md:
   git push origin main || echo "⚠️  Push failed — changes committed locally but not pushed"
   ```
6. **Run the Bootstrap Check** from `.claude/skills/poor-man-memory/SKILL.md` (`## Bootstrap Check` section).
7. Respect the verbosity setting from `config.md`:
   - `silent` — no output, just the agent status indicator
   - `summary` — one-line confirmation (e.g. "Memory saved: updated decisions.md, timeline.md")
   - `verbose` — full detail of what changed

## Notes

- This skill is a shortcut — it does exactly what Phase 3 does, but with an explicit trigger
- The "What changed" block should summarise everything notable since the last memory save (check `memory/last.md` for the last recorded state)
- If nothing has changed since the last save, skip the agent dispatch and say "Nothing new to save"
- Compatible with `/loop` for recurring saves: `/loop 5m /pmm-save`
