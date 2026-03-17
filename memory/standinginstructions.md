# Standing Instructions

Persistent rules and directives that always apply, regardless of session context.
Append-only — never delete or modify existing entries.
These take precedence over session-level instructions when there is a conflict.

## Format

**[Date added] — [Instruction]**
Scope: [always / for X context only]
Reason: [why this was added]

---

**2026-03-16 — Memory update agents are silent**
Scope: always
Reason: user does not want verbose updates on memory tasks. The agent status indicator is sufficient. Do not announce memory updates, summarise what was updated, or tell the user the agent is running.

**2026-03-16 — Agent permission fallback for git operations**
Scope: always
Reason: Agents dispatched for memory operations may not have Bash tool access. If an agent cannot run git add/commit/push, it must signal the main context to handle those operations. Never silently skip the commit.

**2026-03-17 — No Claude/Anthropic attribution in docs or skill files**
Scope: always
Reason: NominexHQ is the project owner. Co-Authored-By lines are acceptable in git commits (for contributor stats) but must not appear in README, SKILL.md, templates, reference docs, or any user-facing content.

**2026-03-17 — Memory updates do not require user acknowledgement**
Scope: always
Reason: Adding new facts, decisions, lessons, or any other entries to memory files should happen proactively based on the trigger table. Do not ask the user for permission before saving to memory — just do it. The user trusts the system to capture what matters.

**2026-03-18 — Always use branch → PR → merge workflow, never push directly to main**
Scope: always
Reason: Three direct pushes to main violated the established PR workflow. All commits must go through: create feature branch → push to remote → open PR → review/approve → merge. Never push directly to main.

**2026-03-18 — Proactively hydrate template-only files during Phase 5**
Scope: always
Reason: taxonomies.md remained empty despite 16 other files being populated, because hydration was only triggered by explicit request. During Phase 5, detect files with structure but no data entries and populate them proactively from existing memory before the maintain cycle runs.
