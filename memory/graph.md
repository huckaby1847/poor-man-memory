# Graph

How everything in this project relates. Typed edges between concepts, decisions, entities, and processes.
Append-only — add new relationships, never remove existing ones.
Rendered as a visual graph in Obsidian. Traversable by Claude as structured context.

## Format

[[Node A]] → relationship → [[Node B]]
[[Node A]] → relationship → [[Node B]] <!-- [namespace:name] -->
<!-- attribution comment is optional — use when provenance of an edge matters -->

Use typed relationships from references/graph-syntax.md.

---

## Structure
[[vectors.md]] → extends → [[graph.md]]
[[SKILL.md]] → uses → [[Agent Dispatch]]
[[Agent Dispatch]] → enables → [[Clean Main Context]]
[[poor-man-memory]] → contains → [[vectors.md]]
[[poor-man-memory]] → contains → [[graph.md]]
[[poor-man-memory]] → contains → [[SKILL.md]]

## Dependencies
[[Agent Dispatch]] → depends-on → [[Bash Permissions]]
[[Git Commit Fallback]] → fixes → [[Agent Bash Permission Gap]]

## Semantic
[[vectors.md]] → similar-to → [[graph.md]]
[[graph.md]] → contrasts-with → [[vectors.md]]

## Epistemic
[[Agent Dispatch Decision]] → ratified-by → [[User]]
[[vectors.md Addition]] → ratified-by → [[User]]
[[Permission Fallback]] → inferred-from → [[Agent Bash Permission Gap]]

## Operational
[[poor-man-memory]] → owned-by → [[User]]
[[poor-man-memory]] → owned-by → [[NominexHQ]]
[[poor-man-memory]] → status → [[v1.0 Shipped]]
[[GitHub Repo]] → uses → [[poor-man-memory]]

## Config & Settings
[[config.md]] → controls → [[Phase Behaviour]]
[[config.md]] → replaces → [[preferences.md]] <!-- for operational settings only -->
[[/pmm-settings]] → writes-to → [[config.md]]
[[summaries.md]] → extends → [[timeline.md]]
[[summaries.md]] → part-of → [[poor-man-memory]]
[[config.md]] → part-of → [[poor-man-memory]]

## Repository
[[poor-man-memory-repo]] → contains → [[.claude/skills/]]
[[poor-man-memory-repo]] → contains → [[CLAUDE.md]]
[[poor-man-memory-repo]] → contains → [[.claude/settings.json]]
[[poor-man-memory-repo]] → contains → [[README.md]]
[[GitHub Repo]] → is-a → [[https://github.com/NominexHQ/poor-man-memory]]

## System Structure
[[PMM]] → contains → [[17 Memory Files]]
[[PMM]] → depends-on → [[git]]
[[BOOTSTRAP.md]] → triggers → [[Session Start Agent]]
[[timeline.md]] → enables → [[summaries.md]]
[[graph.md]] → similar-to → [[vectors.md]]

## Phases
[[config.md]] → controls → [[Init Phase]]
[[config.md]] → controls → [[Session Start Phase]]
[[config.md]] → controls → [[Maintain Phase]]
[[config.md]] → controls → [[Recall Phase]]
[[config.md]] → controls → [[Hydrate Phase]]

## People & Orgs
[[Nominex]] → owns → [[PMM]]
[[Raffi]] → owned-by → [[NominexHQ]]
[[Leith]] → owned-by → [[NominexHQ]]
[[Raffi]] → uses → [[raffi-ismail]]
[[Leith]] → uses → [[leith-dev]]

## Skills
[[/pmm-settings]] → writes-to → [[config.md]]
[[/pmm-dump]] → reads-from → [[graph.md]]
[[/pmm-dump]] → reads-from → [[vectors.md]]
[[/pmm-dump]] → reads-from → [[timeline.md]]
[[/pmm-viz]] → reads-from → [[graph.md]]
[[/pmm-viz]] → reads-from → [[vectors.md]]
[[/pmm-viz]] → reads-from → [[timeline.md]]
[[/pmm-viz]] → uses → [[D3.js v7.9.0]]
[[/pmm-viz]] → uses → [[pmm-viz-template.html]]
[[/pmm-status]] → reads-from → [[config.md]]
[[/pmm-status]] → reads-from → [[Memory Files]]
[[/pmm-update]] → reads-from → [[GitHub Repo]]
[[/pmm-update]] → writes-to → [[System Files]]
[[pmm-viz-template.html]] → part-of → [[pmm/ Directory]]
[[D3.js v7.9.0]] → part-of → [[pmm/ Directory]]
[[version.json]] → part-of → [[pmm/ Directory]]

## Visualization Architecture
[[D3.js force-directed graph]] → enables → [[Interactive memory visualization]]
[[Type-colored nodes]] → part-of → [[D3.js force-directed graph]]
[[Search filters]] → part-of → [[D3.js force-directed graph]]
[[Time slider]] → part-of → [[D3.js force-directed graph]]
[[Cluster convex hulls]] → part-of → [[D3.js force-directed graph]]
[[Time slider]] → depends-on → [[firstSeen/lastSeen timestamps]]
[[firstSeen/lastSeen timestamps]] → tracks → [[Node/Edge temporal evolution]]

## Dispatch
[[Agents]] → writes-to → [[Memory Files]]
[[Main Context]] → uses → [[git]]
[[/pmm-viz]] → triggers → [[Subagent for D3.js rendering]]

## Query & Recall
[[Phase 4 Recall]] → implicit → [[Automatic summarization]]
[[/pmm-query]] → explicit → [[Manual search and filtering]]
[[/pmm-query]] → extends → [[Phase 4 Recall]]
[[/pmm-query]] → uses → [[vectors.md]] <!-- for deep traversal: similarity pairs ≥0.6 -->
[[/pmm-query]] → uses → [[graph.md]] <!-- for deep traversal: one-hop edge traversal -->
[[/pmm-query]] → uses → [[taxonomies.md]] <!-- for deep traversal: sibling broadening -->
[[/pmm-query]] → supports → [[Free-text search]]
[[/pmm-query]] → supports → [[Attribution filter (by namespace:name)]]
[[/pmm-query]] → supports → [[Date filters (since/before)]]
[[/pmm-query]] → supports → [[File scope (in <file>)]]
[[/pmm-query]] → supports → [[Deep traversal mode]]
[[/pmm-query]] → supports → [[Prose output (default)]]
[[/pmm-query]] → supports → [[Dump mode (verbatim)]]
[[Deep traversal]] → expands-via → [[Vector clusters]]
[[Deep traversal]] → expands-via → [[Graph edges]]
[[Deep traversal]] → expands-via → [[Taxonomy siblings]]

## Bootstrap Check System
[[Bootstrap Check]] → fixes → [[Memory auto-load failure]]
[[Bootstrap Check]] → triggers → [[User awareness prompt]]
[[Memory auto-load failure]] → caused-by → [[Missing @memory/BOOTSTRAP.md import in CLAUDE.md]]
[[BOOTSTRAP.md]] → enables → [[Session Start Agent auto-load]]
[[CLAUDE.md]] → must-import → [[BOOTSTRAP.md]]
[[bootstrap_reminder config flag]] → controls → [[Bootstrap Check prompts]]
[[Bootstrap Check]] → integrated-in → [[Init Phase]]
[[Bootstrap Check]] → integrated-in → [[/pmm-save]]
[[Bootstrap Check]] → integrated-in → [[/pmm-hydrate]]
[[Bootstrap Check]] → integrated-in → [[/pmm-update]]
[[Bootstrap Check]] → integrated-in → [[/pmm-status]]
[[Bootstrap Check]] → integrated-in → [[/pmm-query]]

## Bash Permission Rules
[[Bash permission rules]] → use → [[shell wildcards]]
[[Bash(git commit -m *)]] → correct-pattern → [[Permission rule syntax]]
[[Bash(git commit -m 'memory:*')]] → violates → [[Permission rule syntax]]
[[.claude/settings.json]] → contains → [[Bash permission rules]]
[[poor-man-memory-repo template]] → contains → [[Bash permission rules]]
[[Wildcard validation]] → checks-at → [[Claude Code startup]]

## GitHub Account Management
[[Leith]] → identity → [[leith-dev]]
[[Raffi]] → identity → [[raffi-ismail]]
[[PR workflow]] → requires → [[Correct GitHub account]]
[[gh pr create]] → must-use → [[leith-dev authentication]]
[[PR #21]] → violates → [[PR account workflow]]
[[PR #22]] → replaces → [[PR #21]]
[[version.json]] → categorizes → [[.claude/settings.json]] <!-- as merge, not auto-apply -->
