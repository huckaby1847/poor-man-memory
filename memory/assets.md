# Assets

Key entities this project involves — people, tools, systems, organisations.
Updated when new entities are introduced.

## People

| Name | Role | Notes |
|---|---|---|
| Raffi (raffi-ismail) | Admin, reviewer, PMM creator | Reviews and merges PRs, admin of NominexHQ |
| Leith (leith-dev) | Public-facing identity | Creates PRs, commits use leith-dev@users.noreply.github.com |

## Tools & Systems

| Name | Purpose | Notes |
|---|---|---|
| poor-man-memory | Git-backed structured memory for Claude Code | 17 files, clone-and-go repo, v1.0 shipped |
| SKILL.md | Agent dispatch logic for memory operations | Governs init, session-start, maintain, recall, hydrate phases |
| vectors.md | Semantic similarities, clusters, embedding registry | Companion to graph.md — implicit weighted relationships |
| graph.md | Explicit typed relationship graph | Uses edge vocabulary from references/graph-syntax.md |
| config.md | PMM operational configuration | Save cadence, commit behaviour, window sizes, verbosity, active files |
| /pmm-settings | Skill to re-present preference prompts | Lives at .claude/skills/pmm-settings/ |
| /pmm-dump | ASCII visualization (3 depth levels: status/summary/detailed) | Terminal-friendly memory state output |
| /pmm-viz | Interactive D3.js force-directed graph | Type-colored nodes, search filters, time slider, cluster convex hulls, runs as subagent |
| /pmm-status | Health dashboard command | Quick memory system health checks |
| /pmm-update | Manifest-based upstream sync | Checks for updates, diffs system files, applies with user confirmation |
| pmm/ | User-inspectable artifacts directory | D3.js v7.9.0, HTML template, version.json manifest |
| GitHub repo | https://github.com/NominexHQ/poor-man-memory | Public repo, clone-and-go project |

## Organisations

| Name | Relationship | Notes |
|---|---|---|
| NominexHQ | Creator/owner | GitHub org (https://github.com/NominexHQ), @nominex_ai on X |
| Nominex | Product | "The memory layer for AI agents" — PMM is the open-source prototype |

## Other

<!-- Anything that doesn't fit above -->
