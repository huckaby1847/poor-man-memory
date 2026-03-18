---
name: pmm-query
description: "Query PMM memory files for past decisions, preferences, events, relationships, or any recorded context. Supports free-text questions, attribution filters, date ranges, file scoping, deep similarity-aware traversal, and prose or dump output modes. Read-only."
argument-hint: "<question> [by namespace:name] [since date] [in file] [deep] [dump]"
---

# PMM Query

Explicitly query PMM memory files with optional filtering. Runs as a subagent to keep the main context clean.

**Query:** $ARGUMENTS

## Invocation

- `/pmm-query what did we decide about visualization` — free-text search
- `/pmm-query decisions by user:raffi` — filter by attribution tag
- `/pmm-query timeline since 2026-03-17` — filter by date
- `/pmm-query in lessons` — scope to a specific file
- `/pmm-query visualization deep` — similarity-aware traversal via vectors/graph/taxonomies
- `/pmm-query dump what changed yesterday` — raw verbatim entries grouped by source file
- `/pmm-query deep dump visualization` — deep traversal with raw verbatim output
- `/pmm-query nonexistent-thing` — returns "No record found" when nothing matches

## Behaviour

1. If `$ARGUMENTS` is empty, ask the user what to search for before proceeding.
2. Dispatch a `general-purpose` agent with the prompt below. Replace `<project-root>` with the actual project root path and `<user-query>` with `$ARGUMENTS`.
3. Output the agent's returned string verbatim.

### Agent Prompt

> Query PMM memory files. This is a READ-ONLY task — do not edit any files.
>
> **Project root:** `<project-root>`
> **User query:** `<user-query>`
>
> ### Step 1 — Parse Query
>
> Extract the following from the user query:
> - **Question / keyword:** the core search term (everything that is not a filter or modifier)
> - **Attribution filter:** if query contains `by namespace:name` (e.g. `by user:raffi`, `by agent:leith`), extract `namespace:name`
> - **Date filter:** if query contains `since YYYY-MM-DD` or `before YYYY-MM-DD`, extract the direction and date
> - **File scope:** if query contains `in <filename>` (e.g. `in decisions`, `in lessons`), extract the file name (without `.md`)
> - **Deep mode:** if query contains the word `deep`, set deep=true and remove it from the keyword
> - **Dump mode:** if query contains the word `dump`, set dump=true and remove it from the keyword
>
> ### Step 2 — Route to Relevant Files
>
> If a file scope is specified, search only that file.
>
> Otherwise, route by question type using this mapping:
> - Decisions / decided / ratified → `decisions.md`
> - Preferences / style / how the user works → `preferences.md`
> - Tone / voice / reasoning / lens → `voices.md`
> - Recent work / latest / just did → `last.md`, `progress.md`
> - Relationships / how things relate → `graph.md`, `vectors.md`
> - History / arc / timeline → `timeline.md`
> - Rules / directives / standing → `standinginstructions.md`
> - People / tools / systems → `assets.md`
> - Facts / long-term / background → `memory.md`
> - Processes / workflows → `processes.md`
> - Mistakes / lessons / errors → `lessons.md`
> - Categories / naming / taxonomy → `taxonomies.md`
> - Ambiguous / broad → read all active files
>
> Read `<project-root>/memory/config.md` first to confirm which files are active. Skip deactivated files.
>
> ### Step 3 — Search
>
> For each target file:
> 1. Read the file
> 2. Match lines/entries containing the keyword (case-insensitive)
> 3. Apply attribution filter: if set, only include entries whose line (or nearby heading) contains `[namespace:name]` matching the filter
> 4. Apply date filter: if set, only include entries whose date prefix (`YYYY-MM-DD`) satisfies the condition (≥ since date, or ≤ before date)
> 5. Collect all matching entries with their source file
>
> ### Step 4 — Deep Traversal (deep mode only)
>
> **Skip this step if deep=false.**
>
> If deep=true, expand the result set using similarity, graph, and taxonomy data — regardless of whether Step 3 found results.
>
> **4a — Vector cluster expansion (`vectors.md`):**
> 1. Read `vectors.md`
> 2. Find any cluster whose name or member list contains the keyword
> 3. For each matched cluster, collect all member concepts
> 4. Also find any similarity line (`[[A]] ↔ [[B]] | score: ...`) where A or B matches the keyword — collect the paired concept if score ≥ 0.6
> 5. Search all active memory files for each expanded concept. Add any new matches to results, tagged `[via vectors]`
>
> **4b — Graph edge traversal (`graph.md`):**
> 1. Read `graph.md`
> 2. Find all edges where the keyword appears in either node (`[[keyword]]`)
> 3. Collect the neighbour nodes (one hop only)
> 4. Search all active memory files for each neighbour. Add any new matches to results, tagged `[via graph]`
>
> **4c — Taxonomy broadening (`taxonomies.md`):**
> 1. Read `taxonomies.md`
> 2. Find any category or classification that contains the keyword, or that the keyword belongs to
> 3. Collect sibling terms in that category
> 4. Search all active memory files for each sibling. Add any new matches to results, tagged `[via taxonomy]`
>
> Deduplicate — if a result was already found in Step 3, do not list it again. Only surface genuinely new entries from deep traversal.
>
> ### Step 5 — Fallback Chain
>
> If Steps 3 and 4 together return no results:
> 1. Check `timeline.md` and `last.md` for any mention of the keyword
> 2. If still nothing, run: `git log --all --grep="<keyword>" --oneline` (substitute the keyword)
> 3. For each matching commit, run `git show <hash> -- memory/` to read the file content at that commit and extract relevant lines
> 4. If still nothing, return: "No record found in the memory files."
>
> Never hallucinate past context. If it's not in the files or git history, it wasn't recorded.
>
> ### Step 6 — Cross-Reference Enrichment
>
> Skip this step if deep=true (graph.md was already traversed in Step 4b).
>
> Otherwise, if results mention a named entity (person, tool, system, concept) that also appears in `graph.md` or `assets.md`:
> - Read those files
> - Append a brief "Related context" note (1–2 lines) if it adds meaningful information
> - Do not bloat the output — only include cross-references that genuinely enrich the result
>
> ### Step 7 — Format Output
>
> **Choose the output branch based on dump mode:**
>
> ---
>
> #### Branch A — Prose mode (default, dump=false)
>
> Synthesize a narrative answer from all collected results. Do not list files with `---` separators.
>
> Rules:
> - Write in concise, direct prose — answer the question, don't describe what files say
> - Weave evidence from multiple source files into a coherent response
> - Cite sources inline as parentheticals: `(decisions.md)`, `(timeline.md, 2026-03-17)`
> - Preserve attribution tags inline where relevant: `[user:raffi]`
> - For deep-mode results, note provenance naturally in the text: "A related concept, X (via graph), also shows..."
> - If git history was the source: "(from git history, commit abc1234)"
> - End with a single `Sources:` footer line listing all files that contributed
> - If no results after all fallbacks: return "No record found in the memory files."
> - No header block, no match counts — start directly with the narrative
>
> Prose output format:
> ```
> <synthesized narrative answering the user's question, citing sources inline>
>
> Sources: decisions.md, timeline.md, graph.md
> ```
>
> ---
>
> #### Branch B — Dump mode (dump=true)
>
> Return the raw structured format:
>
> ```
> PMM Query Results
> =================
> Query: <original query>
> Filters: <attribution filter> | <date filter> | <file scope> (or "none" if no filters)
> Mode: <deep+dump | dump>
> Found: N result(s) in M file(s)
>
> --- <filename>.md ---
> <verbatim matching entry, including attribution tag if present>
>
> --- <filename>.md [via vectors] ---
> <entry found through cluster/similarity expansion>
>
> --- <filename>.md [via graph] ---
> <entry found through graph edge traversal>
>
> --- <filename>.md [via taxonomy] ---
> <entry found through taxonomy broadening>
>
> [Related context]
> <brief enrichment from graph.md/assets.md, if applicable>
> ```
>
> - Group results by source file
> - Show the full entry (heading + body) for each match, not just the matching line
> - Preserve attribution tags verbatim (e.g., `[user:raffi]`, `[agent:leith]`)
> - Tag deep-traversal results with their provenance (`[via vectors]`, `[via graph]`, `[via taxonomy]`)
> - If a fallback source (git history) was used, note it: `--- git history (commit abc1234) ---`
> - If no results after all fallbacks: return `No record found in the memory files.`
> - No preamble — start directly with `PMM Query Results`

## Notes

- The agent does all file reads and git operations — main context stays clean
- Output the agent's return value verbatim
- Phase 4 in the main PMM skill handles implicit recall mid-conversation; this command is the explicit, filterable version
