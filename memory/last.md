# Last Session

The last few significant actions in detail.
Always replaced — this is a window, not a log.
<!-- Entry format: **[Date]** — [Action] [namespace:name?] -->
<!-- attribution: [user:name], [agent:name], or [system:process] — who originated this. Optional. -->

**2026-03-19** — v1.8.0 Tier-aware auto-memory pointer format implemented: flat pointer format `"See PMM memory/<file>.md"` replaced with explicit tier-aware format distinguishing Tier 1 (in-context, no Read needed) vs Tier 2 (on-disk, Read required). Three files updated consistently: memory/BOOTSTRAP.md (live), .claude/skills/poor-man-memory/references/templates.md (new install template), .claude/skills/poor-man-memory/SKILL.md (Rules section). Eliminates unnecessary pointer-triggered reads for in-context content. [user:raffi]

**2026-03-19** — PR #33 (fix/v1.8.0-tier-aware-memory-pointers) created from local main (which held 3 unpushed commits: v1.8.0 feat, prior memory save, tier-aware fix). Local main reset to origin/main, branch pushed by leith-dev. PR created and reviewed by raffi-ismail: "Good fix — flat format was ambiguous. Tier 1 is already in context, pointing to Read is unnecessary noise. Two-level format explicit. Three files consistent, template updated. LGTM." Merged (squash), branch deleted. Correct workflow demonstrated: branch → PR → merge, never direct push to main. [system:process]

**2026-03-19** — Memory files updated: decisions.md appended with three new entries (tier-aware format decision, v1.8.0 fix shipped, PR #33 workflow); timeline.md appended with v1.8.0 implementation and PR #33 dates; progress.md updated to reflect v1.8.0 completion and updated Next section. graph.md and vectors.md updated with tier-aware pointer edges and context-memory similarity. summaries.md updated with v1.8.0 tier-aware pointer session summary. [system:process]
