# Ingest a source

Read the schema in `CLAUDE.md`. Then process `<FILENAME>` from `raw/`. Specifically:

1. Read the full source document.
2. Discuss the 3–5 key takeaways with me before writing anything. Wait for my confirmation.
3. Create a summary page in `wiki/` for the source itself.
4. Update `wiki/index.md` with the new page(s).
5. Update ALL relevant entity and concept pages across the wiki — people, organizations, concepts, doctrines, statutes, events, anything that appears in the source and deserves its own page.
6. Add backlinks from existing pages that now relate to the new content.
7. Flag any contradictions with existing wiki content using the `> CONTRADICTION:` format from the schema.
8. Append an entry to `wiki/log.md`.

A single source should touch roughly 10–15 wiki pages. If it touches fewer than 5, ask whether the source is too narrow or you're being too conservative. If more than 20, ask whether you're fragmenting concepts that should live on one page.

Every factual claim on every page must cite its source with `[Source: filename.md]`. No exceptions.
