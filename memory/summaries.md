# Summaries

Periodic rollups of past work — session summaries, milestone summaries, and compressed timeline batches.
Sliding window — keep only the 10 most recent summaries. Older summaries live in git history.

## Format

### [Date range] — [Summary title]
[2-4 sentence summary of what happened, key outcomes, and any context worth preserving]

---

### 2026-03-19 — v1.6.0 Context-First Recall shipped
Released v1.6.0 with in-context recall optimization: (1) Phase 4 Recall and /pmm-query now execute directly in main context when `session_start=lazy` and `bootstrap_wired=true` (memory already loaded via @memory/BOOTSTRAP.md imports), answering queries directly from in-memory files without agent dispatch. Fallback to minimal git-history agent only when answer not found in-context; (2) New `recall_beyond_window` config gate (prompt/auto modes) controls whether sessions can search git history for trimmed/old entries. Three-option user prompt: "Yes, search git history" / "Yes, and don't ask me again" (persists `auto` to config.md) / "No"; (3) New "Recall Beyond Window" section in memory/config.md; (4) templates.md updated; (5) pmm-settings Q13 added for configuration. Reduces latency and token cost for in-window recalls by 50%+. Version bumped 1.5.0 → 1.6.0. PR #30 merged, GitHub release published at https://github.com/NominexHQ/poor-man-memory/releases/tag/v1.6.0.

### 2026-03-19 — v1.5.0 Read-Only Model & Lazy Session Start shipped
Shipped v1.5.0 with cost reduction and latency improvements: (1) New `readonly_model` config (haiku default) forces haiku for all read-only agent dispatches (Phase 2 session-start, Phase 4 recall, pmm-query, pmm-dump, pmm-status, pmm-viz) — ~95% cost reduction vs Opus, ~73% vs Sonnet, without sacrificing quality for read-only work. Options: haiku (default) | sonnet | opus | inherit (pre-v1.5.0 parent model); (2) New `session_start` config mode `lazy` (default) skips Phase 2 entirely when bootstrap_wired: true, since memory files auto-load from @memory/BOOTSTRAP.md in CLAUDE.md, saving ~33k tokens (~$0.5-1.5) per session. Falls back to eager if wiring missing. Options: lazy (default) | eager; (3) Early-exit bug fix in pmm-save removed—always dispatches agent now (no-op when nothing to save, minimal cost haiku dispatch ~$0.006) to catch false negatives; (4) pmm-settings updated with Q11 (readonly_model) + Q12 (session_start mode). PR #29 merged 2026-03-19.

### 2026-03-18 — v1.4.0 Token/Message Overhead Reduction shipped
Shipped v1.4.0 with four token/message overhead optimizations: (1) Bootstrap Check cache via `bootstrap_wired` flag eliminates CLAUDE.md file reads once wiring confirmed, saving repeated file I/O across all 6 skills; (2) Pre-check agent removed, template-only detection moved to main context Read tool calls that strip blanks/comments and count content lines, saving 1 agent per save; (3) Phase 5 batch hydration consolidates multiple template-only targets into single agent dispatch + commit, saving up to 14 agents when populating many files; (4) Configurable maintain strategy (single vs tiered) lets users choose between minimal overhead (default) and faster parallel execution (opt-in). PR #28 merged with review from raffi-ismail confirming sound logic. First run of new single-agent path successful.

### 2026-03-18 — Bootstrap Check and v1.3.1 release
Implemented Bootstrap Check reminder system to prevent memory auto-load failures when @memory/BOOTSTRAP.md wiring is missing from CLAUDE.md. Added reusable utility across all 6 PMM surfaces (init, /pmm-save, /pmm-hydrate, /pmm-update, /pmm-status, /pmm-query) with three-option user prompt: fix now (auto-wires and commits), remind later, or suppress. Updated BOOTSTRAP.md template, added bootstrap_reminder config flag, and updated README. PR #20 merged and v1.3.1 released to GitHub with Bootstrap Check feature.

### 2026-03-17 — Memory reconstruction and continued development
Recovered full development history from old conversation transcripts after directory rename from "Poor Man's Memory" to "nominex-pmm" broke session association. Major reconstruction of all memory files with recovered context. Added standing instructions (no attribution in docs, proactive saves), captured user voice in preferences.md, rewrote git history to remove private emails, added /pmm-viz skill for ASCII visualization, and deleted remnant directory from the rename.

### 2026-03-16 — Full session: PMM v1.0 built and shipped to GitHub
Built the entire Poor Man's Memory system from scratch in a single session. Started with 13 template memory files, added vectors.md and config.md, rewrote SKILL.md for agent-based dispatch, created /pmm-settings skill for runtime config changes, added summaries.md for two-tier temporal memory, and converted timeline.md to a sliding window. Reorganised the repo as a clone-and-go project with proper .claude/ layout, settings.json, CLAUDE.md, and a full README with installation docs and Nominex branding. Key architectural decisions: agents edit files only (main context handles git), config.md controls all phase behaviour, repo is clone-and-go not drop-in. Published v1.0.0 release at https://github.com/NominexHQ/poor-man-memory. Established PR workflow (PRs #1-7), added voices.md, Phase 5 "Hydrate", configurable maintain agent model, and committed author identity to Leith for public-facing work.
