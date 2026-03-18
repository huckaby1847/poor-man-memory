# Last Session

The last few significant actions in detail.
Always replaced — this is a window, not a log.
<!-- Entry format: **[Date]** — [Action] [namespace:name?] -->
<!-- attribution: [user:name], [agent:name], or [system:process] — who originated this. Optional. -->

**2026-03-19** — PR #30 (feat: v1.6.0 — context-first recall, recall_beyond_window config) created by leith-dev on branch v1.6.0-context-first-recall, reviewed and approved by raffi-ismail with comment on context-first pattern execution, Phase 4 and /pmm-query gates, beyond-window consistency, 'don't ask me again' persistence, and safe defaults. PR merged to main by raffi-ismail. [user:leith] [user:raffi] [system:process]

**2026-03-19** — v1.5.0 Released: Read-Only Model & Lazy Session Start (1) readonly_model: haiku config (default) for all read-only agents — ~95% cost reduction vs Opus; (2) session_start: lazy config (default) skips Phase 2 when bootstrap_wired: true — saves ~33k tokens per session; (3) Early-exit bug fix in pmm-save (always dispatch). pmm-settings Q11 + Q12 added. Version bumped 1.5.0 in pmm/version.json. PR #29 merged by raffi-ismail. [user:raffi] [agent:leith] [system:process]

**2026-03-18** — v1.4.0 Token/Message Overhead Reduction: (1) bootstrap_wired flag skips CLAUDE.md reads once wired; (2) pre-check agent removed, template detection moved to main context; (3) batch hydration in Phase 5; (4) configurable maintain strategy (single/tiered). PR #28 reviewed and merged by raffi-ismail. [user:raffi] [agent:leith] [system:process]
