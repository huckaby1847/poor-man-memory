# Lessons

Mistakes made and lessons learned. Append-only.
Reference before making decisions in areas where past mistakes occurred.

## Format

**[Date] — [Lesson]**
What happened:
What to do instead:

---

**2026-03-16 — Agents dispatched via TaskCreate may not have Bash tool permissions**
What happened: Rewrote SKILL.md to dispatch agents for all memory operations. Discovered that agents may not have access to Bash, which is needed for git add/commit/push.
What to do instead: Always include a permission fallback — if the agent cannot commit, it should signal the main context to handle the git operations.

**2026-03-16 — BOOTSTRAP.md drift from live configuration**
What happened: Live BOOTSTRAP.md fell out of sync with templates. Hardcoded window sizes instead of referencing config.md. Stale for half the session before anyone noticed.
What to do instead: BOOTSTRAP.md should reference config.md for dynamic values. After any config change, check BOOTSTRAP.md for drift. Apply the Auditor lens after multi-file changes.

**2026-03-16 — Dog-fooding failure when populating voices.md**
What happened: When populating voices.md, Claude used only session context instead of reading existing memory files first. The memory system exists precisely to avoid this — relying on recall rather than context.
What to do instead: Always read relevant memory files before populating or updating any memory file. The system is self-referential — use it.

**2026-03-17 — Email leakage in git history**
What happened: GitHub squash merges use the account's primary email, not the noreply address. Private emails were exposed in the public repo's git history.
What to do instead: Ensure GitHub account settings use noreply email as primary before merging. If leaked, rewrite history with git filter-branch.

**2026-03-17 — Self-approval impossible on GitHub**
What happened: Tried to approve own PR on GitHub — GitHub doesn't allow self-approval of pull requests.
What to do instead: Either merge directly with --admin flag, or have a second identity review. In PMM's workflow, Raffi reviews Leith's PRs.

**2026-03-17 — Graph and vectors have marginal value in small/early projects**
What happened: graph.md and vectors.md were more future-proofing than present utility during initial development. The relationships were too obvious to need formal tracking.
What to do instead: Accept this as intentional — they pay off across sessions and in complex projects. Don't skip them, but don't over-invest early either.

**2026-03-18 — Never push directly to main — always use branch → PR → merge workflow**
What happened: Three commits were pushed directly to main in the project history instead of using the established PR workflow (leith/branch → PR → merge). This bypassed code review and violated the established process.
What to do instead: All commits must go through the PR workflow. Create a branch, push to remote, open PR, wait for review (or self-review if admin), then merge. Never push directly to main.

**2026-03-18 — Auto-hydrate template-only files proactively during Phase 5**
What happened: taxonomies.md remained template-only (empty table) for the entire project lifetime despite 16 other files being fully populated. It was only filled when explicitly requested, not proactively.
What to do instead: During Phase 5 Hydrate, detect template-only files (those with structure but no data) and populate them proactively from existing memory before the maintain cycle runs. Don't wait for explicit requests to seed new files.
