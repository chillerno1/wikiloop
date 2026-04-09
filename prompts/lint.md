# Lint the knowledge base

Run a full health check on `wiki/` per the lint workflow in `CLAUDE.md`. Check for:

- **Contradictions** between pages (same claim, different answers)
- **Stale claims** superseded by newer sources
- **Orphan pages** with no inbound links
- **Concepts mentioned but never explained** — terms used in multiple pages without a dedicated page
- **Missing cross-references** — pages that should link to each other but don't
- **Claims without source attribution** — anything missing `[Source: ...]`

Write findings to `wiki/lint-report-<YYYY-MM-DD>.md` with severity levels:
- 🔴 errors (contradictions, unsourced claims)
- 🟡 warnings (orphans, stale content, missing links)
- 🔵 info (suggestions, minor polish)

End the report with **3 specific sources** that would fill the biggest knowledge gaps — what to ingest next, and why.
