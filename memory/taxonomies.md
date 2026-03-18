# Taxonomies

Classification systems, categories, and naming conventions used in this project.
Updated when new classification systems are established or existing ones refined.
Track changes — note when a taxonomy evolves so historical references remain interpretable.

## Format

### [Taxonomy Name]
*Purpose: what this classifies*
*Last updated: [date]*

| Term | Definition | Notes |
|---|---|---|
| | | |

---

### Memory File Types
*Purpose: classification of how memory files behave and are maintained*
*Last updated: 2026-03-17*

| Term | Definition | Notes |
|---|---|---|
| Append-only | Entries are immutable after creation; never delete or modify past entries | Used for: decisions.md, timeline.md, standinginstructions.md, graph.md (edges only), vectors.md (embedding registry only) |
| Living document | Update in place; sections are revised as understanding evolves | Used for: memory.md, assets.md, preferences.md, processes.md, voices.md, lessons.md, progress.md, vectors.md (similarities/clusters) |
| Sliding window | Fixed max entries; oldest entries trimmed to git when limit is reached | Applied to: timeline.md (max 50), summaries.md (max 10) |
| Replace entirely | Always overwritten in full, never merged or appended | Used for: last.md (the current recent-context window) |
| Immutable | Never edited except by explicit user instruction | Used for: BOOTSTRAP.md |
| Configuration | Operational control; defines PMM phase behaviour | Used for: config.md |

### Operational Phases
*Purpose: the execution cycle for memory system operations*
*Last updated: 2026-03-17*

| Term | Definition | Trigger | Output |
|---|---|---|---|
| Init (Phase 1) | Initialisation — scaffold memory system in new project | First run, memory/ doesn't exist | All template files created, config written, git initialised |
| Session Start (Phase 2) | Read and summarise all memory files at session entry | Session begins | Structured summary absorbed into context |
| Maintain (Phase 3) | Update memory files with new facts, decisions, lessons | Major milestone, explicit save, trigger table match | Updated files, git commit |
| Recall (Phase 4) | Search memory for past context on user query | User asks "what did we decide about X" | Relevant findings returned verbatim from files |
| Hydrate (Phase 5) | Populate new file from existing memory in non-greenfield install | New file added, existing memory exists | New file seeded with context inferred from other files |

### Commit Message Prefixes
*Purpose: standardised prefixes in git commit messages to indicate the type of change*
*Last updated: 2026-03-16*

| Prefix | Used for | Example |
|---|---|---|
| `memory:` | Memory file updates and maintenance | `memory: update decisions and timeline` |
| `feat:` | New features and skills | `feat: add /pmm-save command` |
| `fix:` | Bug fixes | `fix: accurate memory claims` |
| `docs:` | Documentation changes | `docs: update README` |

### Command Naming
*Purpose: CLI command naming convention and namespace*
*Last updated: 2026-03-17*

| Pattern | Purpose | Examples |
|---|---|---|
| `/pmm-*` | Poor Man's Memory subsystem commands | `/pmm-save`, `/pmm-settings`, `/pmm-viz`, `/pmm-dump`, `/pmm-status`, `/pmm-update` |
| `/loop` | Recurring execution wrapper | `/loop 5m /pmm-save` runs pmm-save every 5 minutes |

### Entity Types (in graph.md)
*Purpose: node categories for explicit relationship graph*
*Last updated: 2026-03-17*

| Type | Examples | Role |
|---|---|---|
| Files | memory.md, graph.md, SKILL.md, BOOTSTRAP.md | Core data structures |
| Concepts | Agent Dispatch, Clean Main Context, Config as Source of Truth | Architectural ideas |
| Decisions | Agent Bash Permission Gap, vectors.md Addition, Phase 5 "Hydrate" | Ratified choices |
| Processes | Memory Operation Dispatch, PR Workflow, Identity Separation | Established workflows |
| People | Raffi, Leith, User | Human agents |
| Systems | poor-man-memory, PMM, D3.js, GitHub | Tools and platforms |
| Phases | Init Phase, Session Start Phase, Maintain Phase, Recall Phase, Hydrate Phase | Operational stages |

### Edge Types (in graph.md)
*Purpose: relationship vocabulary for typed edges between nodes*
*Last updated: 2026-03-16*

| Edge Type | Meaning | Example |
|---|---|---|
| → uses → | X uses/depends on Y | SKILL.md uses Agent Dispatch |
| → enables → | X makes Y possible | Agent Dispatch enables Clean Main Context |
| → contains → | X holds/includes Y | poor-man-memory contains vectors.md |
| → depends-on → | X requires Y to function | Agent Dispatch depends-on Bash Permissions |
| → fixes → | X resolves Y | Git Commit Fallback fixes Agent Bash Permission Gap |
| → similar-to → | X and Y are semantically similar | vectors.md similar-to graph.md |
| → contrasts-with → | X and Y represent opposing views | graph.md contrasts-with vectors.md |
| → ratified-by → | X was approved/endorsed by Y | Agent Dispatch Decision ratified-by User |
| → inferred-from → | X was deduced from Y | Permission Fallback inferred-from Agent Bash Permission Gap |
| → owned-by → | X is owned/controlled by Y | poor-man-memory owned-by NominexHQ |
| → status → | X has status Y | poor-man-memory status v1.0 Shipped |
| → writes-to → | X modifies Y | /pmm-settings writes-to config.md |
| → reads-from → | X accesses Y | /pmm-dump reads-from graph.md |
| → triggers → | X initiates Y | BOOTSTRAP.md triggers Session Start Agent |
| → part-of → | X is a constituent of Y | D3.js v7.9.0 part-of pmm/ Directory |
| → is-a → | X is an instance of Y | GitHub Repo is-a https://github.com/NominexHQ/poor-man-memory |
| → replaces → | X supersedes Y (for operational purposes) | config.md replaces preferences.md |
| → extends → | X builds on or enhances Y | vectors.md extends graph.md |

### Voice/Tone Profiles
*Purpose: communication styles and reasoning lenses*
*Last updated: 2026-03-16*

| Voice | Context | Traits | Category |
|---|---|---|---|
| Direct | Routine work, quick decisions | Minimal, no filler, action-oriented | Output persona |
| Technical | Architecture, code review, debugging | Precise, references specifics, quantified | Output persona |
| Explanatory | Onboarding, docs, "why" questions | Clear, structured, analogies | Output persona |
| Proposer | Presenting options, suggesting next steps | Concise options with tradeoffs | Output persona |
| Shipping | Milestones, releases, pushes | Outcome-focused, frames as live | Output persona |
| Critic | Decision review, risk assessment | Finds risks, failure modes, assumptions | Internal lens |
| Pragmatist | Scope expansion, rising complexity | Simplifies, favours separation of concerns | Internal lens |
| Explorer | Stuck situations, adjacent possibilities | Considers alternatives | Internal lens |
| Auditor | Multi-file changes, before shipping | Checks consistency, completeness | Internal lens |
| Systematiser | Lessons learned, patterns to enshrine | Turns one-off fixes into durable processes | Internal lens |
| Dog-fooder | Self-referential work, tool validation | Checks if we're using our own tools | Internal lens |

### Cluster Categories (semantic groups in vectors.md)
*Purpose: conceptual groupings of related files and entities*
*Last updated: 2026-03-17*

| Cluster | Theme | Members |
|---|---|---|
| recent-context | Files tracking temporal state and recency | last.md, progress.md, timeline.md |
| append-only | Files with immutable history | decisions.md, timeline.md, standinginstructions.md, graph.md |
| identity | Files defining user and project identity | preferences.md, voices.md, assets.md, memory.md |
| semantic-layer | Explicit and implicit relationships | graph.md, vectors.md |
| self-referential | PMM describing/governing itself | SKILL.md, memory.md, processes.md |
| temporal-memory | Multiple time resolutions | timeline.md, summaries.md, last.md |
| operational | System behaviour controls | config.md, BOOTSTRAP.md, standinginstructions.md |

### Configuration Options
*Purpose: allowed values and defaults for config.md settings*
*Last updated: 2026-03-19*

| Setting | Allowed Values | Default | Notes |
|---|---|---|---|
| Save Cadence | every-milestone, every-N-messages, on-request-only | every-milestone | Can be overridden with `/loop` |
| Commit Behaviour | auto-commit, session-end, manual | auto-commit | Determines when git commits happen |
| Sliding Window (timeline) | light (30), moderate (50), heavy (100), unlimited | moderate (50) | Controls trimming frequency |
| Sliding Window (summaries) | light (5), moderate (10), heavy (20), unlimited | moderate (10) | When timeline trims, summaries are created |
| Verbosity | silent, summary, verbose | silent | Standing instruction prefers silent |
| Maintain Agent Model | haiku, sonnet, opus | haiku | Session-start/recall use parent model |
| Active Files | Multi-select from all 15 files | All active | config.md and BOOTSTRAP.md always active |
| Maintain Strategy | single, tiered | single | v1.4.0: single is default (1 agent, minimal overhead); tiered is opt-in (3-agent parallel, faster but higher cost). Changed via /pmm-settings Q8. |
| Bootstrap Wired | false, true | false | v1.4.0: false = new install, Bootstrap Check reads CLAUDE.md; true = wiring confirmed, check skips file reads. Auto-set to true after "Fix it now" or manual wiring. |
| Readonly Model | haiku, sonnet, opus, inherit | haiku | v1.5.0: forces haiku for read-only agents (Phase 2, Phase 4, pmm-query, pmm-dump, pmm-status, pmm-viz) — ~95% cost reduction vs Opus. Changed via /pmm-settings Q11. |
| Session Start | lazy, eager | lazy | v1.5.0: lazy skips Phase 2 when bootstrap_wired=true (memory auto-loads from @memory/BOOTSTRAP.md); eager always dispatches. Changed via /pmm-settings Q12. |
| Recall Beyond Window | prompt, auto | prompt | v1.6.0: controls whether to search git history for trimmed/old entries. prompt (default) = ask user with 3-option question; auto = silently search (persists from "don't ask me again"). Changed via /pmm-settings Q13. |

### GitHub Identity Scheme
*Purpose: role-based commit authors for this project*
*Last updated: 2026-03-16*

| Identity | Email | Role | Usage | Repository |
|---|---|---|---|---|
| Raffi (raffi-ismail) | raffi-ismail@users.noreply.github.com | Admin, reviewer, creator | PR review, merges, admin operations | All (private and public) |
| Leith (leith-dev) | leith-dev@users.noreply.github.com | Public-facing author | Feature commits, PRs | NominexHQ repos |

### Phase 3 Maintain Strategies
*Purpose: dispatch strategy selection for Phase 3 memory maintenance*
*Last updated: 2026-03-18*

| Strategy | Default | Execution Model | Dispatch | Token Cost | When to Use |
|---|---|---|---|---|---|
| Single | Yes | 1 agent updates all 15 files sequentially | 1 agent total, reads all files, writes all files in single pass | Minimal (~10-20k tokens per save) | Typical installs, token budget constrained, minimal overhead is priority |
| Tiered | No (opt-in) | 3 concurrent agents by file dependency — Tier 1+2 parallel, Tier 3 after | 3 agents concurrent (Tier 1+2) + 1 sequential (Tier 3) = 4 concurrent calls, but only 3 active at once | Higher (~15-25k+ tokens per save) | Large installs with many files, performance is priority over token economy, parallel execution desired |

### Phase 3 Maintain Dispatch Patterns (v1.3.3+)
*Purpose: concurrency patterns for Phase 3 memory maintenance*
*Last updated: 2026-03-18*

| Pattern | Trigger | Execution Model | Use Case |
|---|---|---|---|
| Tier-based Dispatch | Maintain Strategy: tiered (opt-in) | Tier 1+2 parallel (4 event + 8 content files each), Tier 3 sequential after (3 relational files) | Multi-file updates where parallelism benefit exceeds agent dispatch overhead |
| Concurrent Pre-check | Before any Tier-based Dispatch (or Single dispatch) | Single read-only agent, reads all active files, counts content lines | Detect template-only files before maintaining to trigger proactive hydration |
| Single Sequential | Maintain Strategy: single (default) | 1 agent reads config, then updates all 15 files sequentially in single dispatch | Minimise agent overhead, suitable for most installs, best token economy |

### Bootstrap Check Cache Strategy
*Purpose: optimization for Bootstrap Check initialization across 6 PMM skills*
*Last updated: 2026-03-18*

| Phase | Flag State | Behaviour | File I/O |
|---|---|---|---|
| First run (new install) | `bootstrap_wired: false` (default in template) | Bootstrap Check reads CLAUDE.md to detect wiring; if missing, prompts user; user selects "Fix it now" or other option | 1 file read per check invocation |
| After fix or auto-wire | `bootstrap_wired: true` (set by Fix It Now step) | Bootstrap Check skips CLAUDE.md read entirely; assumes wiring is confirmed and valid | 0 file reads; cache bypass |
| Subsequent sessions | `bootstrap_wired: true` (persists in config.md) | All 6 PMM skills skip Bootstrap Check file read; cache remains valid | Eliminated across all invocations |
