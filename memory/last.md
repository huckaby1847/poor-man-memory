# Last Session

The last few significant actions in detail.
Always replaced — this is a window, not a log.
<!-- Entry format: **[Date]** — [Action] [namespace:name?] -->
<!-- attribution: [user:name], [agent:name], or [system:process] — who originated this. Optional. -->

**2026-03-19** — v1.5.0 Read-Only Model & Lazy Session Start shipped: (1) `readonly_model: haiku` config added (default) to force haiku for all read-only agent dispatches: session-start Phase 2, recall Phase 4, pmm-query, pmm-dump, pmm-status, pmm-viz. ~95% cost reduction vs Opus, ~73% vs Sonnet. Options: haiku | sonnet | opus | inherit (pre-v1.5.0 behaviour). (2) `session_start: lazy` config added (default) skips Phase 2 agent when `bootstrap_wired: true`; memory files auto-loaded via @memory/BOOTSTRAP.md in CLAUDE.md, saves ~33k tokens per session. Options: lazy | eager. (3) Early-exit bug fix in pmm-save: removed "nothing to save" check that produced false negatives when memory wasn't loaded at session start; now always dispatches haiku agent (no-op when nothing to save, ~$0.006 cost). (4) pmm-settings Q11 (readonly agent model) + Q12 (session start mode) added. (5) All read-only skills (pmm-query, pmm-dump, pmm-status, pmm-viz) updated to use `readonly_model` from config. Version bumped 1.4.0 → 1.5.0, released 2026-03-19. [user:raffi] [agent:leith] [system:process]
