# Claude Instructions

## Memory System

This project uses a structured memory system in the `memory/` folder.
All memory operations run via agents (subprocesses) — never in the main context window.

At session start, dispatch an agent to read all files and return a structured summary:

@memory/config.md
@memory/standinginstructions.md
@memory/progress.md
@memory/last.md
@memory/graph.md
@memory/vectors.md
@memory/decisions.md
@memory/taxonomies.md
@memory/memory.md
@memory/assets.md
@memory/preferences.md
@memory/voices.md
@memory/processes.md
@memory/lessons.md
@memory/summaries.md
@memory/timeline.md

If `memory/secrets.md` exists, note that secrets are available for this session. Do not echo or summarise its contents.

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
