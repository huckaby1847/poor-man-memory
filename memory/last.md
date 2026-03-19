# Last Session

The last few significant actions in detail.
Always replaced — this is a window, not a log.
<!-- Entry format: **[Date]** — [Action] [namespace:name?] -->
<!-- attribution: [user:name], [agent:name], or [system:process] — who originated this. Optional. -->

**2026-03-19** — v1.9.0 Tiered Memory Loading implemented: Root cause found — @-imports don't recurse, so BOOTSTRAP.md's @-imports were never resolved by Claude Code. Fix: Moved all 12 Tier 1 files as direct @-imports in CLAUDE.md; kept 4 Tier 2 files (graph.md, vectors.md, taxonomies.md, assets.md) on-demand via haiku agent. CLAUDE.md adds Tier 1 @-imports block + Tier 2 note under ## Memory; BOOTSTRAP.md replaced "dispatch agent at session start" + 16 @-imports with tiered loading instructions. .claude/settings.json updated to allow Edit/Write of memory/* arrays. references/templates.md updated with new BOOTSTRAP template and config Session Start comment. SKILL.md updated Phase 2 lazy description, Phase 4 context-first recall, Bootstrap Check "Fix it now" block. pmm/version.json moved CLAUDE.md from system to merge category, bumped to v1.9.0. [user:raffi] [agent:leith]

**2026-03-19** — v1.8.0 Tier-aware auto-memory pointer format implemented: flat pointer format `"See PMM memory/<file>.md"` replaced with explicit tier-aware format distinguishing Tier 1 (in-context, no Read needed) vs Tier 2 (on-disk, Read required). Three files updated consistently: memory/BOOTSTRAP.md (live), .claude/skills/poor-man-memory/references/templates.md (new install template), .claude/skills/poor-man-memory/SKILL.md (Rules section). Eliminates unnecessary pointer-triggered reads for in-context content. [user:raffi]

**2026-03-19** — PR #33 (fix/v1.8.0-tier-aware-memory-pointers) created from local main (which held 3 unpushed commits: v1.8.0 feat, prior memory save, tier-aware fix). Local main reset to origin/main, branch pushed by leith-dev. PR created and reviewed by raffi-ismail: "Good fix — flat format was ambiguous. Tier 1 is already in context, pointing to Read is unnecessary noise. Two-level format explicit. Three files consistent, template updated. LGTM." Merged (squash), branch deleted. Correct workflow demonstrated: branch → PR → merge, never direct push to main. [system:process]
