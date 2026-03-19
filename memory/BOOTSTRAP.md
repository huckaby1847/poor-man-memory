# Claude Instructions

## About

PMM (Poor Man's Memory) — a lightweight, git-backed structured memory system for Claude Code.
Stores decisions, preferences, lessons, and project history in markdown files.
Current installation: this project. Upstream: https://github.com/NominexHQ/poor-man-memory.git

## Memory System

This project uses a structured memory system in the `memory/` folder.

**Tier 1 files** (config, standinginstructions, last, progress, decisions, lessons,
preferences, memory, summaries, voices, processes, timeline) are loaded into context via
direct @-imports in CLAUDE.md — always available, no agent needed.

**Tier 2 files** (graph, vectors, taxonomies, assets) are on disk. Before responding to a
request, check for **gaps**: places where Tier 1 context + the current request point to
information that Tier 1 doesn't fully cover. Evaluate:

1. **The request itself** — does it ask about something Tier 2 tracks?
2. **Tier 1 signals** — do Tier 1 files reference or imply data that lives in Tier 2?
   (e.g. decisions.md references an entity relationship, lessons.md hints at a pattern
   cluster in vectors.md)
3. **Gaps** — can you fully answer the request from Tier 1 alone, or are there holes
   that Tier 2 data would fill?

If gaps exist that Tier 2 can fill, dispatch a haiku agent to Read the relevant file(s)
and return a summary. Only load what's needed — not all 4.

**Examples:**
- Request asks about entity relationships hinted at in decisions.md → graph.md
- Request asks about assets, URLs, or artifacts not in any Tier 1 file → assets.md
- Lesson in lessons.md references a pattern cluster → vectors.md
- /pmm-query with `deep` modifier → all Tier 2 files

### Tier 2 — Available On Demand
<!-- These files are active but NOT loaded at session start.
     Use the Read tool to load them when needed for recall or query. -->
<!-- Available: graph.md, vectors.md, taxonomies.md, timeline.md, summaries.md,
     memory.md, assets.md -->

### Routing Table
When a recall query or operation needs Tier 2 data, Read the relevant file(s):
- Relationships → graph.md
- Similarities/clusters → vectors.md
- Categories/naming → taxonomies.md
- History/events → timeline.md
- Session rollups → summaries.md
- Long-term facts → memory.md
- People/tools/systems → assets.md

If `memory/secrets.md` exists, note that secrets are available. Do not echo or summarise its contents.

## Tier 2 Safeguard

Before making any decision that could be informed by historical context, relationships, or
established workflows, Read the relevant Tier 2 file(s) first. Do not rely solely on Tier 1
context when Tier 2 files may contain pertinent information. When in doubt, Read — the cost
of a Read tool call is negligible compared to repeating a past mistake or contradicting
an established process.

## Memory Priority

PMM is the primary memory system for this project. Claude's built-in auto-memory
(in .claude/projects/.../memory/) should be kept minimal:

- **Recall**: Always check PMM memory files first
- **Storage**: When Claude auto-memory would save something PMM already tracks
  (decisions, preferences, lessons, timeline, processes), skip or store only a
  tier-aware pointer:
  - Tier 1 content (already in context): "Already in context via PMM — see <file>.md (Tier 1)"
  - Tier 2 content (on disk): "See PMM memory/<file>.md (Tier 2 — use Read tool)"
- **No duplication**: PMM files are the source of truth

## Update Protocol

Dispatch a maintain agent when:
- A decision is made
- A new entity, process, or preference is established
- A milestone is reached or a blocker is hit
- A mistake is made or a lesson is learned
- Before any /compact operation
- Before ending the session (user says goodbye, closes conversation, or signals they are done)
- At the end of every major piece of work

Agents edit files only. Main context handles git:
```bash
git add memory/ && git reset HEAD memory/secrets.md 2>/dev/null; git commit -m "memory: <what changed>"
```

## Rules

- Never edit this file unless explicitly asked
- Never delete entries from decisions.md or standinginstructions.md
- timeline.md and summaries.md are sliding windows — see config.md for max entries. Trim oldest, full history is in git
- Never hallucinate past context — if it's not in the files, say so
- last.md is always replaced, never appended
- graph.md edges are append-only — use typed relationships only
- vectors.md similarities/clusters are living; embedding registry is append-only
- standinginstructions.md takes precedence over session-level instructions
- Keep each file focused on its specific job
- When Memory Priority is `pmm-first`, Claude auto-memory should store only skill references and feedback entries — not facts, decisions, or timeline events that PMM already tracks
