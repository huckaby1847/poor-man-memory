---
name: pmm-save
description: "Trigger a PMM memory save. Dispatches the maintain agent to capture current session state into memory files and commits. Use when the user runs /pmm-save or wants to explicitly save memory. Works with /loop for recurring saves (e.g. /loop 5m /pmm-save)."
---

# PMM Save

Lightweight trigger for Phase 3 (Maintain) of Poor Man's Memory. Captures current session state into memory files.

## Behaviour

1. Read `memory/config.md` to get the maintain agent model (default: `haiku`), active files list, and maintain strategy (default: `single`)
2. **Template-only check:** Read each active file directly in main context using the Read tool. Strip blank lines, `#` headings, HTML comments, and table header/separator rows — if 0 content lines remain, it's template-only. If ANY active files are template-only AND at least 3 other files are populated, dispatch the Phase 5 **batch hydration** agent (single agent for all template-only files at once) BEFORE the maintain cycle. Use the batch hydration prompt from `.claude/skills/poor-man-memory/SKILL.md` (Phase 5 — Batch hydration section). Commit hydrated files: `git add memory/ && git commit -m "memory: hydrate <files> from existing context"`
3. Build a "What changed" summary by reviewing the current conversation since the last save — identify decisions, facts, preferences, milestones, lessons, or any other notable events
4. Dispatch the maintain agent(s) using Phase 3 from `.claude/skills/poor-man-memory/SKILL.md`. **If `Strategy: single`** (default): dispatch one agent for all active files. **If `Strategy: tiered`**: dispatch Tier 1 and Tier 2 agents simultaneously, then Tier 3 after both complete.
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
