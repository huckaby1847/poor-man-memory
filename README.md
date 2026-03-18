# Poor Man's Memory

Persistent structured memory for Claude Code. No infrastructure required — just markdown files and git.

## Poor Man's Memory

AI coding agents have shallow memory. Claude Code persists some context between sessions — preferences, feedback, project notes — but it's flat summaries in a size-capped index. No structure, no relationships, no enrichment. Nuance gets compressed out. Decisions lose their rationale. Lessons lose their context. The agent remembers *that* something happened, but not *why it mattered*.

**Poor Man's Memory** fixes this. It's a structured memory system for Claude Code that persists across sessions using nothing but markdown files and git. No databases, no APIs, no infrastructure to maintain. Clone a repo, say "init memory", and your agent starts remembering.

**Built for:** developers using Claude Code (CLI or IDE) who want their agent to accumulate knowledge over time — across sessions, across days, across the life of a project.

**What it solves:**
- Shallow, unstructured memory that loses nuance over time
- Repeated context-setting because flat summaries aren't enough
- Decisions without rationale, preferences without context, lessons without detail
- No audit trail of what the agent knew and when

## What It Does

Gives Claude a second brain that survives between sessions. Every decision, lesson, preference, and relationship is captured in dedicated markdown files, committed to git, and loaded at the start of each session. Each file has one job — no single blob that loses fidelity over time.

## Installation

This is a **clone-and-go project directory** — no manual setup, no file copying, no configuration wiring. Everything Claude Code needs is already in place (`.claude/skills/`, `settings.json`, `CLAUDE.md`).

```bash
git clone https://github.com/NominexHQ/poor-man-memory.git my-project
cd my-project
claude  # or open with your Claude Code IDE integration
```

Then tell Claude:

```
init memory
```

That's it. Claude will prompt you for preferences (save cadence, verbosity, active files) and scaffold the `memory/` directory. From then on, memory updates happen automatically.

## Adding to an Existing Project

If you already have a project and just want to drop in the memory system:

1. Copy these into your project root:
   ```
   .claude/skills/poor-man-memory/    # Main skill + reference docs
   .claude/skills/pmm-save/           # Explicit save command
   .claude/skills/pmm-query/          # Memory search with filters
   .claude/skills/pmm-hydrate/        # On-demand file hydration
   .claude/skills/pmm-settings/       # Settings command
   .claude/skills/pmm-dump/           # ASCII memory dump (text visualization)
   .claude/skills/pmm-viz/            # Interactive D3.js graph (browser)
   .claude/skills/pmm-status/         # Health dashboard
   pmm/                               # D3.js artifact + HTML template (for /pmm-viz)
   CLAUDE.md                          # Bootstrap instructions for Claude
   ```

2. **(Optional)** Merge the pre-approved git permissions into your existing `.claude/settings.json`:
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
   Skip this if you prefer to approve git commands manually, or if you already have a `settings.json` you don't want to modify.

3. If you already have a `CLAUDE.md`, append the contents rather than overwriting — or just add:
   ```markdown
   ## Memory System
   This project uses Poor Man's Memory. Run `init memory` if the `memory/` directory doesn't exist.
   Run `/pmm-settings` to configure.
   ```

4. Open the project with Claude Code and say `init memory`.

The `memory/` directory will be created inside your project. Add it to version control — git history is the database.

## Memory Files

| File | Purpose | Mutability |
|---|---|---|
| `config.md` | PMM settings | Living |
| `BOOTSTRAP.md` | Load instructions | Immutable |
| `memory.md` | Long-term project facts | Living |
| `assets.md` | People, tools, systems | Living |
| `decisions.md` | Committed decisions | Append-only |
| `processes.md` | Workflows | Living |
| `preferences.md` | User working style | Living |
| `lessons.md` | Mistakes and fixes | Append-only |
| `timeline.md` | Recent events | Sliding window |
| `summaries.md` | Periodic rollups | Sliding window |
| `progress.md` | Current state | Living |
| `last.md` | Last session detail | Always replaced |
| `graph.md` | Typed relationships | Append-only |
| `vectors.md` | Semantic similarities | Living (registry append-only) |
| `taxonomies.md` | Classifications | Living |
| `standinginstructions.md` | Persistent rules | Append-only |

## Commands

| Command | What it does |
|---|---|
| `/pmm-save` | Explicitly trigger a memory save |
| `/pmm-query <question>` | Search memory files — supports attribution, date, and file filters |
| `/pmm-hydrate <file\|all> [force]` | Populate empty/thin memory files from existing context |
| `/pmm-settings` | Change memory system configuration |
| `/pmm-dump` | ASCII memory dump — three levels: status, summary, detailed |
| `/pmm-viz` | Interactive D3.js memory graph — opens in browser |
| `/pmm-status` | Quick health dashboard — initialization, saves, file health |
| `/pmm-update` | Check for and apply PMM system updates from upstream |
| `/loop 5m /pmm-save` | Auto-save memory every 5 minutes |

## Query Syntax

`/pmm-query` accepts a free-text question plus optional modifiers. By default it returns a **synthesized prose answer**. Append `dump` for raw verbatim entries grouped by source file. Modifiers can be combined in any order.

| Modifier | Syntax | Example |
|---|---|---|
| Attribution | `by namespace:name` | `/pmm-query decisions by user:raffi` |
| Date (from) | `since YYYY-MM-DD` | `/pmm-query timeline since 2026-03-17` |
| Date (to) | `before YYYY-MM-DD` | `/pmm-query lessons before 2026-03-01` |
| File scope | `in <filename>` | `/pmm-query in decisions` |
| Deep mode | `deep` | `/pmm-query visualization deep` |
| Dump mode | `dump` | `/pmm-query dump what changed yesterday` |

**Output modes:**
- **Prose (default)** — synthesized narrative answer with inline source citations. Reads like an answer, not a file export.
- **Dump** (`dump`) — raw verbatim entries grouped by source file with match counts. Use when you want to see exactly what's recorded.
- Both modes combine: `/pmm-query deep dump <question>` runs deep traversal and returns raw output.

**Attribution namespaces:**
- `user:name` — something a user explicitly stated, decided, or requested
- `agent:name` — something an agent inferred or synthesized
- `system:process` — generated by an automated process (e.g. hydration)

**Deep mode** (`deep`) enables similarity-aware traversal — when keyword search alone isn't enough. It expands the result set via three additional passes:
- **vectors** — finds cluster members and high-similarity concepts (score ≥ 0.6) from `vectors.md`
- **graph** — follows one-hop edges from matched nodes in `graph.md`
- **taxonomy** — broadens to sibling terms in the same category from `taxonomies.md`

In prose mode, deep results are woven into the narrative naturally. In dump mode, they are tagged with provenance (`[via vectors]`, `[via graph]`, `[via taxonomy]`).

**Examples:**

```
/pmm-query what did we decide about visualization
/pmm-query decisions by user:raffi since 2026-03-17
/pmm-query in lessons by agent:leith
/pmm-query preferences before 2026-03-15
/pmm-query visualization deep
/pmm-query dump what changed yesterday
/pmm-query deep dump D3.js since 2026-03-17
```

If no match is found in any memory file, the command falls back to git history before returning "No record found."

## Recurring Saves

Memory updates happen automatically at milestones, but you can also run saves on a fixed interval:

```
/loop 5m /pmm-save
```

This uses Claude Code's built-in `/loop` command to run `/pmm-save` every 5 minutes — capturing decisions, preferences, and progress without manual intervention. Adjust the interval to your preference.

## Configuration

Run `/pmm-settings` at any time to change:

- **Save cadence** — every milestone, every N messages, or on request only
- **Commit behaviour** — auto-commit, session end, or manual
- **Sliding window size** — how many entries before trimming (git has full history)
- **Verbosity** — silent, summary, or verbose
- **Active files** — deactivate files you don't need

## How Git Works as Your Database

Every memory update is committed to git. Sliding window files (timeline, summaries) are trimmed to keep the working set small, but the full history is always available via `git log`. This gives you:

- Immutable audit trail
- Diffable changes
- Rollback to any point
- Free hosting on GitHub

## Architecture

Memory operations run in **agents** (subprocesses), never in the main context window. This keeps your conversation clean — agents handle file I/O, and the main context commits to git.

## Built by Nominex

Nominex is the memory layer for AI agents.

AI agents have memory, but it's shallow — flat summaries that lose depth over time. Nominex builds the deep memory infrastructure that makes agents structurally smarter, not just bigger per-request.

Poor Man's Memory is the zero-infrastructure starting point — structured markdown and git. For teams that need semantic search, shared memory across agents, and automated enrichment, that's where [Nominex](https://github.com/NominexHQ) comes in.

[GitHub](https://github.com/NominexHQ) | [X](https://x.com/nominex_ai)

## License

MIT
