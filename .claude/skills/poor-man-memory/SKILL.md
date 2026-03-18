---
name: poor-man-memory
description: "Initialise, maintain, and commit a structured memory system for Claude Code sessions using a set of dedicated markdown files backed by a git repository. Use this skill whenever a user wants persistent memory across Claude Code sessions, wants to set up a second brain for their project, asks Claude to remember things across sessions, or wants to track decisions, processes, preferences, lessons, or progress over time. Also use when the user asks to update, commit, or review their memory files. Triggers on phrases like 'remember this', 'set up memory', 'what have we decided', 'update the memory files', 'commit memory', or any request to recall historical context from past sessions."
---

# Poor Man's Memory

A lightweight, git-backed structured memory system for Claude Code. No infrastructure required. Everything is markdown files in a folder. GitHub is your database.

## Core Principle: Agents, Not Main Context

**All memory operations run in agents (subprocesses), never in the main context window.** The main context stays clean. Each phase below describes the agent prompt to dispatch. The agent does the file I/O and returns a concise result.

Use the `general-purpose` agent type for all memory operations. Agents have access to Read, Write, Edit, Glob, and Grep tools.

**Model selection:** The maintain agent uses the model specified in `config.md` (default: `haiku`). Session-start and recall agents inherit the parent model since they need higher fidelity for summarisation and search. When dispatching the maintain agent, pass the `model` parameter from config.

**Agents do NOT run git commands.** After any agent that writes files, the main context handles the commit:

```bash
git add memory/ && git reset HEAD memory/secrets.md 2>/dev/null; git commit -m "memory: <brief description>" && git push origin main 2>/dev/null || true
```

## Reducing Permission Friction

On first use, inform the user that they can pre-approve git commands for memory operations to avoid repeated permission prompts. Guide them to add the following to their `.claude/settings.json` (project-level) or `~/.claude/settings.json` (global):

```json
{
  "permissions": {
    "allow": [
      "Bash(git add memory/*)",
      "Bash(git commit -m 'memory:*')",
      "Bash(git push origin main*)"
    ]
  }
}
```

This allows only memory-scoped git operations — no broader git access is granted. Only mention this once per project, at initialisation or when the user first encounters a permission prompt.

## File Structure

```
memory/
├── config.md                    # PMM configuration — save cadence, commit behaviour, window sizes, verbosity, active files
├── BOOTSTRAP.md                 # Master instructions — immutable unless user explicitly edits
├── memory.md                 # Long-term facts about this project and context
├── assets.md                 # Key entities: people, tools, systems, organisations
├── decisions.md              # Committed decisions — ratified, high confidence
├── processes.md              # Workflows and processes developed over sessions
├── preferences.md            # User-specific quirks, style, working preferences
├── lessons.md                # Mistakes made and lessons learned
├── timeline.md               # Sliding window of recent events (max 20)
├── summaries.md              # Periodic session/milestone rollups (max 10), git has full history
├── progress.md               # Current milestones, state, and what's next
├── last.md                   # Last few actions in detail — high fidelity recent context
├── graph.md                  # How everything relates — typed edges between concepts, decisions, entities
├── vectors.md                # Semantic similarities, concept clusters, and embedding provenance
├── voices.md                 # Tone profiles and internal reasoning patterns
├── taxonomies.md             # Classification systems, categories, and naming conventions used in this project
└── standinginstructions.md   # Persistent rules and directives that always apply — never expire
```

## When to Update

Claude dispatches a maintain agent:
- At the end of every major milestone or decision
- When explicitly asked by the user
- Before a `/compact` operation (to preserve context that would otherwise be lost)
- When a new entity, process, or preference is established
- At natural session breaks

## Phases

### Phase 1 — Initialise

**When:** `memory/` directory doesn't exist.

**Step 1 — Preference prompt:** Before creating any files, present the user with configuration questions using `AskUserQuestion`. This is the same flow triggered by `/pmm-settings` (see below).

Ask these questions (use interactive question tool with options):

**Q1: Save cadence** — How often should memory be updated?
- Every major milestone (default) — updates at decisions, milestones, session breaks
- Every N messages — specify a number (e.g. every 5 messages)
- On explicit request only — only when you ask

*Explain: This depends on Claude Code triggering the skill. For fine-grained control, use `/loop` to run a save prompt on a recurring interval (e.g. `/loop 5m /pmm-save`).*

**Q2: Commit behaviour** — When should changes be committed to git?
- Auto-commit after every update batch (default) — each maintain cycle ends with a commit
- Batch commits at session end only — files are edited throughout, one commit at the end
- Manual commits only — you decide when to commit

*Explain: Git commits are your audit trail and rollback safety net. Auto-commit means you never lose work. Manual gives you control but risks losing updates if you forget.*

**Q3: Sliding window size** — How many entries to keep in windowed files (timeline, summaries) before trimming to git?
- Light (30) — minimal context, fast to load
- Moderate (50, default) — balanced
- Heavy (100) — deep context, more to read at session start
- Unlimited — no trimming, files grow indefinitely

**Q4: Verbosity** — How should memory updates be communicated?
- Silent — agent status indicator only, no announcements
- Summary (default) — one-line confirmation after updates
- Verbose — full detail of what changed

**Q5: Maintain agent model** — Which model should handle memory updates?
- Haiku (default) — fastest and cheapest, good for mechanical file edits
- Sonnet — balanced, better at nuanced updates
- Opus — most capable, highest cost

*Explain: The maintain agent does structured file edits — reading files, appending entries, replacing sections. Haiku handles this well and costs ~10x less than Opus. Session-start and recall agents always use your current model for higher fidelity.*

**Q6: Active files** — Which memory files do you want? All are active by default. Deselect any you don't need.
- [multi-select] memory.md, assets.md, decisions.md, processes.md, preferences.md, voices.md, lessons.md, timeline.md, summaries.md, progress.md, last.md, graph.md, vectors.md, taxonomies.md, standinginstructions.md

*Explain: Deactivated files won't be created and won't appear in BOOTSTRAP.md. You can activate them later with `/pmm-settings`. Core files (config.md, BOOTSTRAP.md) are always active.*

**Step 2 — Write config:** Write the user's responses to `memory/config.md` using the format from `references/templates.md`.

**Step 3 — Scaffold files:** Launch a `general-purpose` agent with this prompt:

> Initialise the poor-man-memory system. This is a WRITE task — create files. Do NOT run any git commands.
>
> 1. Read the templates from `<skill-base>/references/templates.md`
> 2. Create the `memory/` directory
> 3. Read the config from `memory/config.md` to determine which files are active
> 4. Create `memory/config.md` (already done) and `memory/BOOTSTRAP.md` (always created)
> 5. Create each **active** memory file from its template. Skip deactivated files.
> 6. Always create `memory/secrets.md` from its template (regardless of active files list) — it is local-only and gitignored.
> 7. Generate `BOOTSTRAP.md` content listing only the active files in the load order
> 8. Return a confirmation listing all files created and any files skipped.

Replace `<skill-base>` with the actual skill base directory path.

**Step 4 — Git and guidance:**
1. Initialise a git repo if not already initialised
2. `git add memory/ && git commit -m "memory: initialise structured memory system"`
3. Tell the user the memory system is initialised
4. Inform them about pre-approving git commands (see "Reducing Permission Friction" above)
5. Mention: *"Run `/pmm-settings` at any time to change how your memory system behaves."*

### Phase 2 — Session Start

**When:** Start of a session, or when the user asks to recall/review memory.

**Dispatch:** Launch a `general-purpose` agent with this prompt:

> Read all memory files and return a structured summary. This is a READ-ONLY task — do not edit anything.
>
> Read all files in `memory/` in this order:
> 1. `config.md` — PMM configuration (controls behaviour for all phases)
> 2. `BOOTSTRAP.md` — operating instructions
> 3. `standinginstructions.md` — persistent rules that always apply
> 3. `progress.md` — where we are
> 4. `last.md` — what just happened
> 5. `graph.md` — how everything relates
> 6. `vectors.md` — semantic similarities and clusters
> 7. `decisions.md` — what's been committed to
> 8. `taxonomies.md` — classification systems and naming conventions
> 9. `memory.md` — long-term facts
> 10. `assets.md` — key entities
> 11. `preferences.md` — how to work
> 12. `voices.md` — tone profiles and reasoning lenses
> 13. `processes.md` — how things are done
> 14. `lessons.md` — what not to repeat
> 15. `summaries.md` — periodic rollups of past work
> 16. `timeline.md` — the broader arc
>
> Only read files that are active per config.md. Skip deactivated files.
>
> If `memory/secrets.md` exists, note that secrets are available for this session. Do not echo or summarise its contents.
>
> Return a structured summary with these sections:
> - **Configuration** — from config.md (save cadence, commit behaviour, window size, verbosity, active files)
> - **Standing instructions** — any persistent rules (verbatim, these take precedence)
> - **Current state** — from progress.md and last.md
> - **Key decisions** — from decisions.md (all entries, verbatim)
> - **Active relationships** — from graph.md and vectors.md (non-empty entries only)
> - **Context** — from memory.md, assets.md, preferences.md, voices.md, processes.md (non-empty sections only)
> - **Lessons** — from lessons.md (all entries, verbatim)
> - **Timeline** — from timeline.md (last 10 entries)
> - **Taxonomies** — from taxonomies.md (non-empty entries only)
>
> Skip sections where all source files are empty/template-only. Be concise but preserve fidelity — don't paraphrase decisions, instructions, or lessons.

**After agent returns:** Absorb the summary into your working context. Do not repeat it to the user unless asked.

### Phase 3 — Maintain

**When:** New information emerges that should persist (see trigger table below).

**Pre-check — Hydrate template-only files:** Before dispatching the maintain agent, check all active files for template-only status (strip blank lines, headings, comments, table headers — if 0 content lines remain, it's template-only). If any active files are template-only AND at least 3 other files are populated, dispatch Phase 5 (Hydrate) for each template-only file first. This ensures files that were empty since init get populated from existing context before the maintain cycle runs. Commit hydrated files separately.

**Dispatch:** Launch a `general-purpose` agent (in background when possible) with the model from `config.md` (default: `haiku`) and this prompt:

> Update the poor-man-memory files. This is a WRITE task — edit files only. Do NOT run any git commands.
>
> Working directory: `<project-root>`
> Reference files are in `<skill-base>/references/` (graph-syntax.md, vector-syntax.md for format rules).
>
> **First:** Read `memory/config.md` for active configuration. Respect:
> - **Window size** — use the configured max entries for timeline.md and summaries.md
> - **Active files** — only update files that are active. Skip deactivated files.
> - **Protected files** — never read, write, or reference `secrets.md`. It contains sensitive values. If you encounter a secret value in the conversation context, do NOT write it to any memory file.
> - Do NOT modify config.md itself.
>
> **What changed:**
> <describe what happened in the session — decisions made, facts learned, preferences observed, etc.>
>
> **Update rules:**
> - Read each file before editing it
> - Only update files where the new information is relevant (see trigger table)
> - `BOOTSTRAP.md` — NEVER edit
> - `standinginstructions.md` — append-only, never modify existing entries
> - `decisions.md` — append-only, newest at top
> - `timeline.md` — sliding window, keep only the 20 most recent entries (oldest trimmed first). Full history is in git.
> - `summaries.md` — sliding window, keep only the 10 most recent summaries (oldest trimmed first). When timeline entries are about to be trimmed, summarise the batch and append here first. Full history is in git.
> - `graph.md` — append-only, use typed edges per references/graph-syntax.md
> - `vectors.md` — similarities/clusters are living (update in place), embedding registry is append-only. Use formats per references/vector-syntax.md
> - `last.md` — ALWAYS replace entirely with the last 3-5 significant actions
> - `taxonomies.md` — living document, track changes
> - All other files — living documents, update in place
> - Never bleed content between files — each file has one job
>
> **Attribution:** Tag each new entry with its source actor using `[namespace:name]` format:
> - `[user:name]` — a user explicitly stated, decided, or requested this
> - `[agent:name]` — an agent inferred, observed, or synthesized this
> - `[system:process]` — generated by automated process (hydration, import)
> Place the tag at the end of the entry header line: `**[Date] — [Entry]** [namespace:name]`
> Applies to: decisions.md, timeline.md, lessons.md, standinginstructions.md, last.md
> For graph.md edges: optionally append `<!-- [namespace:name] -->` after the edge line.
> Use the actor names from the conversation context (e.g., [user:raffi], [agent:leith]).
> If unsure of the source, omit the tag. Do not guess.
>
> **Trigger table:**
> | File | Update trigger |
> |---|---|
> | `memory.md` | New long-term fact established |
> | `assets.md` | New entity introduced (person, tool, system) |
> | `decisions.md` | Decision made and committed to |
> | `processes.md` | New process established or existing one updated |
> | `preferences.md` | User preference observed or stated, or user communication pattern noticed (vocabulary, decision style, request framing) |
> | `voices.md` | New tone profile defined, internal dialogue pattern established or refined |
> | `lessons.md` | Mistake made or lesson explicitly noted |
> | `timeline.md` | Major milestone or event worth preserving |
> | `summaries.md` | Session end, major milestone completed, or timeline entries about to be trimmed — summarise and append |
> | `progress.md` | State changes — milestone reached, blocker hit, next action shifts |
> | `last.md` | Always — replace with the last 3-5 significant actions |
> | `graph.md` | New relationship discovered, decision affects another concept |
> | `vectors.md` | New semantic similarity discovered, cluster formed or revised, entity embedded |
> | `taxonomies.md` | New category, classification system, or naming convention established |
> | `standinginstructions.md` | User issues a persistent rule or directive |
>
> Return a one-line summary of what was updated.

Replace `<project-root>`, `<skill-base>`, and the "What changed" block with actual values.

**After agent returns:** Main context commits:
```bash
git add memory/ && git commit -m "memory: <brief description>" && git push origin main 2>/dev/null || true
```

### Phase 4 — Recall

**When:** User asks about past context ("what did we decide about X", "what's my preference for Y", "what happened with Z").

**Dispatch:** Launch a `general-purpose` agent with this prompt:

> Search the poor-man-memory files for information about: <user's question>
> This is a READ-ONLY task — do not edit anything.
>
> Search strategy:
> 1. Check the most relevant memory file(s) first based on the question type:
>    - Decisions → decisions.md
>    - Preferences → preferences.md
>    - Tone/voice/reasoning → voices.md
>    - Recent work → last.md, progress.md
>    - Relationships → graph.md, vectors.md
>    - History → timeline.md
>    - Rules → standinginstructions.md
>    - People/tools → assets.md
>    - Facts → memory.md
>    - Processes → processes.md
>    - Mistakes → lessons.md
>    - Categories → taxonomies.md
> 2. If not found, check `timeline.md` and `last.md`
> 3. If still not found, search git history: `git log --all --grep="<keyword>" --oneline`
> 4. If still not found, say: "No record found in the memory files."
>
> Never hallucinate past context. If it's not in the files, it wasn't recorded.
> When returning results, include the attribution tag if present (e.g., "[user:raffi]" or "[agent:leith]").
> This tells the user who originated the information.
> Return the relevant information verbatim where possible, with the source file noted.

Replace `<user's question>` with the actual query.

**After agent returns:** Relay the findings to the user. If nothing was found, say so honestly.

**Tip:** Users can also run `/pmm-query <question>` for explicit recall with filtering support (attribution, date range, file scope).

### Phase 5 — Hydrate (new files in existing installations)

**When:** A new memory file is added to the skill (via PMM update) but the user already has an existing `memory/` directory with populated files. The new file would be created from its empty template, missing all the context that existing files already hold.

**This is not a greenfield install.** The existing memory files contain history, decisions, preferences, and patterns that should inform the new file's initial content.

**Dispatch:** Launch a `general-purpose` agent with this prompt:

> Hydrate a newly added memory file from existing memory. This is a WRITE task — edit the new file only. Do NOT run any git commands.
>
> **New file:** `<new-file-name>` (just created from template — currently empty/boilerplate)
> **Purpose:** `<what this file captures>`
> **Reference:** `<skill-base>/references/<relevant-syntax>.md` for format rules
>
> **Instructions:**
> 1. Read ALL existing memory files to build context:
>    - timeline.md, summaries.md — what happened over time
>    - decisions.md — what was decided and why
>    - lessons.md — what went wrong and what to do instead
>    - preferences.md — how the user works
>    - processes.md — established workflows
>    - standinginstructions.md — persistent rules
>    - memory.md — long-term facts
>    - assets.md — people, tools, systems
>    - graph.md, vectors.md — relationships and similarities
>    - last.md, progress.md — recent context
> 2. Infer content for the new file based on what the existing files reveal.
>    - Do not copy content — synthesise. Each file has one job.
>    - Use the format defined in the reference doc.
>    - Only add entries you can justify from the existing memory. Do not hallucinate.
> 3. Write the inferred content to the new file. Use `[system:hydrate]` as the attribution tag for all hydrated entries.
> 4. Return a summary of what was inferred and from which source files.

Replace `<new-file-name>`, `<purpose>`, `<skill-base>`, and `<relevant-syntax>` with actual values.

**After agent returns:** Main context commits:
```bash
git add memory/<new-file> && git commit -m "memory: hydrate <new-file> from existing memory"
```

**When to trigger:**
- After a PMM version update that introduces new memory files
- When a user activates a previously deactivated file (via `/pmm-settings`) in a project with existing memory
- When the user explicitly asks to populate a file from existing context

**Important:** Always hydrate before the first maintain cycle touches the new file. An empty file that gets maintained stays shallow — a hydrated file starts with the full context the system already has.

## Rules

- `BOOTSTRAP.md` is immutable — never edit without explicit user instruction
- `standinginstructions.md` entries are append-only — never delete or modify existing instructions
- `decisions.md` entries are append-only — never delete or modify past decisions
- `last.md` is always replaced, never appended — it's the current window, not a log
- `timeline.md` is a sliding window — keep only the 20 most recent entries, oldest trimmed first. Full history lives in git.
- `summaries.md` is a sliding window — keep only the 10 most recent summaries, oldest trimmed first. Full history lives in git. When timeline entries are trimmed, summarise the batch and append here before trimming.
- `graph.md` edges are append-only — add new relationships, never remove existing ones
- `vectors.md` similarities and clusters are living documents — update scores and memberships as understanding evolves. Embedding registry entries are append-only.
- `taxonomies.md` is a living document — update classifications as they evolve, but track changes
- All other files are living documents — update in place
- Commit after every meaningful update, not just at session end
- Keep each file focused on its job — don't bleed content between files
- In `graph.md`, always use typed edges — never bare links without a relationship label
- `standinginstructions.md` takes precedence over session-level instructions — if there is a conflict, standing instructions win

## User Commands

### /pmm-settings

Re-presents the same preference prompts from Phase 1 at any time. The user can change any option — save cadence, window size, commit behaviour, verbosity, active files. Updates are written to `memory/config.md` and take effect immediately.

When invoked:
1. Read current `memory/config.md` and show the user their current settings
2. Present the same 5 questions from Phase 1, pre-filled with current values
3. Write updated responses to `memory/config.md`
4. If active files changed, update `memory/BOOTSTRAP.md` to reflect the new file list
5. Commit: `git add memory/config.md memory/BOOTSTRAP.md && git commit -m "memory: update PMM configuration"`

This command is implemented as a separate skill at `.claude/skills/pmm-settings/SKILL.md`.

### /pmm-dump

Renders PMM memory state as inline ASCII visualizations. Three depth levels:

- `/pmm-dump` — heatmap only (quick status check)
- `/pmm-dump summary` — heatmap + cluster list + last 5 timeline entries
- `/pmm-dump detailed` — full ASCII: graph map + heatmap + similarity matrix + clusters

This command is implemented as a separate skill at `.claude/skills/pmm-dump/SKILL.md`.

### /pmm-viz

Interactive D3.js force-directed graph visualization. Parses all memory files, generates an HTML file with embedded D3.js, and opens it in the browser. Runs as a subagent.

- `/pmm-viz` — full graph (all memory files)
- `/pmm-viz graph` — relationships from graph.md only
- `/pmm-viz clusters` — cluster members + similarity edges only
- `/pmm-viz timeline` — event nodes + decision nodes + temporal edges

Artifacts live in `pmm/` at the project root (D3.js, HTML template, cached output). This command is implemented as a separate skill at `.claude/skills/pmm-viz/SKILL.md`.

### /pmm-status

Quick health dashboard. Shows initialization state, last save time, recent commits, file health, and warnings.

- `/pmm-status` — show full status dashboard

This command is implemented as a separate skill at `.claude/skills/pmm-status/SKILL.md`.

### /pmm-save

Explicitly triggers a memory save (Phase 3 — Maintain). Captures current session state into memory files and commits.

- `/pmm-save` — save now
- Compatible with `/loop` for recurring saves: `/loop 5m /pmm-save`

This command is implemented as a separate skill at `.claude/skills/pmm-save/SKILL.md`.

### /pmm-query

Search memory files for past decisions, preferences, events, relationships, or any recorded context.
Supports free-text questions plus optional filters (attribution, date range, file scope).

- `/pmm-query what did we decide about visualization` — free-text search
- `/pmm-query decisions by user:raffi` — filter by attribution
- `/pmm-query timeline since 2026-03-17` — filter by date
- `/pmm-query in lessons` — scope to a specific file

This command is implemented as a separate skill at `.claude/skills/pmm-query/SKILL.md`.

### /pmm-update

Checks the upstream PMM repository for updates and applies them safely. System files (skills, templates, artifacts) are updated; user data (memory/) is never touched. Uses `pmm/version.json` as the version manifest.

- `/pmm-update` — check for updates and apply if available

This command is implemented as a separate skill at `.claude/skills/pmm-update/SKILL.md`.

## Reference Files

- `references/templates.md` — initial content templates for all memory files
- `references/graph-syntax.md` — edge types, relationship vocabulary, and graph.md examples
- `references/vector-syntax.md` — similarity format, cluster format, embedding registry, and vectors.md examples
- `references/voice-syntax.md` — tone profile format, internal dialogue format, and voices.md examples

## Artifact Files

The `pmm/` directory at the project root contains user-inspectable artifacts for the interactive visualization:

- `pmm/d3.v7.min.js` — D3.js v7 minified (dependency for interactive graph)
- `pmm/pmm-viz-template.html` — HTML template with data/D3 placeholders
- `pmm/viz-cache.html` — Generated visualization output (gitignored, regenerated on demand)
