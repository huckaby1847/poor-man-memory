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

Public commits on NominexHQ repos use the Leith identity (leith-dev@users.noreply.github.com). Raffi's identity stays off the NominexHQ repo commit history. Raffi acts as admin/reviewer only.

## Skill-to-Repo Sync
*Established: 2026-03-16*

After editing files in `.claude/skills/`, the changes are copied to `poor-man-memory-repo/` and committed. The repo is the canonical distribution; the local skills directory is the working copy.

## Git Commit Format
*Established: 2026-03-16*

- `memory: <what>` — for memory file updates
- `feat:` / `fix:` / `docs:` — for skill/code changes

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
