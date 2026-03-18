# Processes

Workflows and processes developed or established during this project.
Updated when new processes are created or existing ones change.

## Memory Operation Dispatch
*Established: 2026-03-16*

All memory operations (init, session-start, maintain, recall) are dispatched to agents (subprocesses) via SKILL.md. The main context window stays clean — agents handle file reads, edits, and git operations, then return concise results.

**Fallback**: If the dispatched agent lacks Bash permissions (e.g., cannot run git commands), the agent signals this and the main context handles git add/commit/push directly.

## PR Workflow
*Established: 2026-03-16*

Leith (leith-dev) creates PRs. Raffi (raffi-ismail) reviews and merges. Squash merge, delete branch after merge. Full PR cycles can be delegated to agents.

## Identity Separation
*Established: 2026-03-16*
*Strengthened: 2026-03-18 after second email leak*

Public commits on NominexHQ repos use the Leith identity (leith-dev@users.noreply.github.com). Raffi's identity stays off the NominexHQ repo commit history. Raffi acts as admin/reviewer only.

**CRITICAL**: This process has failed twice (2026-03-17 and 2026-03-18), with private emails leaking into git history. Before every merge:
1. Verify local git config is set to noreply address (e.g., `48171824+raffi-ismail@users.noreply.github.com` for Raffi)
2. Run identity audit on the branch: `git log --pretty=format:"%an %ae" | sort | uniq` and verify no private emails appear
3. Only merge after audit passes; if any private emails are found, rewrite history with `git filter-branch` before merging

## Skill-to-Repo Sync
*Established: 2026-03-16*

After editing files in `.claude/skills/`, the changes are copied to `poor-man-memory-repo/` and committed. The repo is the canonical distribution; the local skills directory is the working copy.

## Git Commit Format
*Established: 2026-03-16*

- `memory: <what>` — for memory file updates
- `feat:` / `fix:` / `docs:` — for skill/code changes

## Phase 3 Maintain Dispatch Strategy
*Established: 2026-03-18*

Configurable maintain strategy in config.md (Strategy: single | tiered):
- **Single** (default): One agent updates all 15 memory files sequentially. Minimal overhead, correct for typical installs. Better token/message economy.
- **Tiered** (opt-in): Three concurrent agents grouped by file dependency. Tier 1 (event files: last, timeline, summaries, progress) + Tier 2 (content files: decisions, lessons, preferences, memory, processes, voices, assets, instructions) run in parallel. Tier 3 (relational files: graph, vectors, taxonomies) runs after both tiers complete, reading updated state. Faster for large installations but higher per-save token cost. Dispatch strategy set via /pmm-settings Q8 at any time.

## /pmm-query Query Pattern
*Established: 2026-03-18*

Explicit recall command separate from Phase 4 Recall. Supports modular filtering and traversal:
- Free-text search (default prose output with source citations)
- `by <namespace:name>` — filter by author attribution
- `since <date>` / `before <date>` — temporal bounds
- `in <file>` — scope to specific memory file(s)
- `deep` — expand via vector clusters (≥0.6 similarity), graph edge traversal, taxonomy sibling broadening
- `dump` — switch to verbatim entries grouped by file (instead of prose)
- Modifiers stack: e.g., `deep what was...` or `dump by user:raffi in decisions.md since 2026-03-17`
- Dispatched using `readonly_model` (haiku default, configurable) — read-only work, no reasoning required

## Phase 2 Session Start Dispatch
*Established: 2026-03-16*
*Updated: 2026-03-19 with lazy mode*

Configurable phase behaviour via `session_start` config setting:
- **Lazy** (default): Skip Phase 2 agent entirely when `bootstrap_wired: true`. Memory files auto-load from @memory/BOOTSTRAP.md direct @-imports in CLAUDE.md (no agent dispatch needed). Saves ~33k tokens (~$0.5-1.5) per session. Falls back to eager if wiring not detected or `bootstrap_wired: false`.
- **Eager**: Always dispatch Phase 2 agent to read and synthesize memory files (pre-v1.5.0 behaviour). Full read token cost (~10-18k tokens).
- Dispatched using `readonly_model` (haiku default, configurable) — read-only summarization work.

## Read-Only Agent Model Selection
*Established: 2026-03-19*

Configurable model for all read-only agent dispatches (Phase 2, Phase 4, pmm-query, pmm-dump, pmm-status, pmm-viz) via `readonly_model` config:
- **Haiku** (default): Cheapest option for read-only work. ~95% cost reduction vs Opus, ~73% vs Sonnet. Sufficient for file reads and summarization without reasoning.
- **Sonnet**: Middle-ground model, better quality summaries. ~5x cost of haiku, ~20% cost of Opus.
- **Opus**: Most capable, original pre-v1.5.0 behaviour (high cost for read-only work).
- **Inherit**: Use parent context model (pre-v1.5.0 behaviour). Falls back when config not set.
- Set via /pmm-settings Q11 (readonly_model) at any time.
