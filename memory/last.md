# Last Session

The last few significant actions in detail.
Always replaced — this is a window, not a log.
<!-- Entry format: **[Date]** — [Action] [namespace:name?] -->
<!-- attribution: [user:name], [agent:name], or [system:process] — who originated this. Optional. -->

**2026-03-19** — v1.6.0 Context-First Recall shipped: (1) Phase 4 Recall (SKILL.md) now checks if `session_start=lazy` and `bootstrap_wired=true`; if so, answers recall queries directly from in-context memory files (already loaded via @memory/BOOTSTRAP.md in CLAUDE.md) instead of dispatching an agent. Only falls back to minimal git-history agent when answer not found in context, gated behind user permission prompt `recall_beyond_window: prompt|auto`. (2) pmm-query/SKILL.md updated with same context-first pattern: in lazy mode, all 5 query steps (parse, route, search, deep traversal, cross-reference enrichment) execute in main context; git history fallback also gated behind recall_beyond_window. (3) memory/config.md: added new "## Recall Beyond Window" section with default "Mode: prompt". (4) templates.md: added Recall Beyond Window section to config template. (5) pmm-settings/SKILL.md: added Q13 for recall_beyond_window (prompt/auto), added to settings summary display. (6) pmm/version.json bumped 1.5.0 → 1.6.0. Version released 2026-03-19. [user:raffi] [agent:leith] [system:process]
