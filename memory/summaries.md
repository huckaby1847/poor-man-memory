# Summaries

Periodic rollups of past work — session summaries, milestone summaries, and compressed timeline batches.
Sliding window — keep only the 10 most recent summaries. Older summaries live in git history.

## Format

### [Date range] — [Summary title]
[2-4 sentence summary of what happened, key outcomes, and any context worth preserving]

---

### 2026-03-18 — Bootstrap Check and v1.3.1 release
Implemented Bootstrap Check reminder system to prevent memory auto-load failures when @memory/BOOTSTRAP.md wiring is missing from CLAUDE.md. Added reusable utility across all 6 PMM surfaces (init, /pmm-save, /pmm-hydrate, /pmm-update, /pmm-status, /pmm-query) with three-option user prompt: fix now (auto-wires and commits), remind later, or suppress. Updated BOOTSTRAP.md template, added bootstrap_reminder config flag, and updated README. PR #20 merged and v1.3.1 released to GitHub with Bootstrap Check feature.

### 2026-03-17 — Memory reconstruction and continued development
Recovered full development history from old conversation transcripts after directory rename from "Poor Man's Memory" to "nominex-pmm" broke session association. Major reconstruction of all memory files with recovered context. Added standing instructions (no attribution in docs, proactive saves), captured user voice in preferences.md, rewrote git history to remove private emails, added /pmm-viz skill for ASCII visualization, and deleted remnant directory from the rename.

### 2026-03-16 — Full session: PMM v1.0 built and shipped to GitHub
Built the entire Poor Man's Memory system from scratch in a single session. Started with 13 template memory files, added vectors.md and config.md, rewrote SKILL.md for agent-based dispatch, created /pmm-settings skill for runtime config changes, added summaries.md for two-tier temporal memory, and converted timeline.md to a sliding window. Reorganised the repo as a clone-and-go project with proper .claude/ layout, settings.json, CLAUDE.md, and a full README with installation docs and Nominex branding. Key architectural decisions: agents edit files only (main context handles git), config.md controls all phase behaviour, repo is clone-and-go not drop-in. Published v1.0.0 release at https://github.com/NominexHQ/poor-man-memory. Established PR workflow (PRs #1-7), added voices.md, Phase 5 "Hydrate", configurable maintain agent model, and committed author identity to Leith for public-facing work.
