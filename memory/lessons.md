# Lessons

Mistakes made and lessons learned. Append-only.
Reference before making decisions in areas where past mistakes occurred.

## Format

**[Date] — [Lesson]** [namespace:name?]
<!-- attribution: [user:name], [agent:name], or [system:process] — who originated this. Optional. -->
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

**2026-03-18 — Private email leaked in git history again (second occurrence)**
What happened: After PR #15 merge, a pre-merge identity check revealed two private emails leaking across 17 commits in the full git history: [redacted personal email] (15 commits) and [redacted personal email] (2 commits). This is the second time this has occurred (first was 2026-03-17). History was rewritten via git filter-branch and force-pushed to three branches.
What to do instead: The standing process check before merge is mandatory — verify git config is set to noreply address and run identity inspection before every merge. This is a repeat pattern that requires stricter enforcement. Add pre-merge email audit to the PR workflow checklist.

**2026-03-18 — Quoted shell wildcards in permission rules break validation** [agent:leith]
What happened: Permission rule `Bash(git commit -m 'memory:*')` had `*` inside a quoted string, causing Claude Code startup validation to fail. Rule was skipped silently, leaving users without permission for critical operations.
What to do instead: Wildcards must NOT be inside quoted strings in permission rules. Use `Bash(git commit -m *)` instead. Fixed in both nominex-pmm .claude/settings.json and poor-man-memory-repo template. Check SKILL.md for outdated example documentation.

**2026-03-18 — Repeated GitHub account mix-up (third time, PR #12 → #21 → ???)** [system:process]
What happened: PR #21 created under raffi-ismail instead of leith-dev. This is the third time this mistake has occurred (PR #12 and now #21). Pattern: wrong account selected during gh pr create, only caught post-hoc.
What to do instead: Add pre-PR checklist step that verifies GitHub CLI is authenticated as the correct identity (leith-dev) before running gh pr create. Consider git config aliases or environment checks to enforce branch → PR identity. Document feedback in memory/preferences.md and standinginstructions.md.

**2026-03-18 — Settings merge category blocks /pmm-update auto-apply** [agent:leith]
What happened: `.claude/settings.json` in version.json has category `merge` (manual merge required), so /pmm-update will NOT auto-apply the Bash wildcard fix to existing user installs. Users must update manually or re-run /pmm-update with confirmation.
What to do instead: Consider whether critical security/stability fixes should be in an auto-apply category. For settings.json changes, retain merge category (risky to auto-merge) but document fix prominently in release notes and send targeted notification to users (future: add notification framework to /pmm-update).
