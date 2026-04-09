# Reconcile experience into the wiki

Use this when a source represents **captured experience** — a retro, a post-mortem, a "what actually happened" note — rather than curated reading material. Experience sources often contradict existing wiki content, and the reconciliation step exists to layer corrections on top of the old claims without erasing history.

## Prompt

> Read `CLAUDE.md`. Then process `<retro-or-experience-filename.md>` from `raw/` as a **reconciliation source**. This source represents real-world experience and may contradict existing wiki content.
>
> Do the following:
>
> 1. Read the full source.
> 2. Discuss the key divergences from existing wiki content with me and wait for confirmation before writing. Walk through each WIKI GAP, CONTRADICTS WIKI, and NEW KNOWLEDGE marker one by one.
> 3. For every claim in existing wiki pages that this source contradicts:
>    - Add a `> CONTRADICTION:` callout that preserves the old claim, names the old source, states the new claim, cites the experience source, and explains *why* the old claim turned out to be wrong.
>    - Do NOT delete the old claim.
>    - Update the page's `last_updated` date and bump `staleness_risk` on any still-active curated source whose claim was contradicted.
> 4. For every NEW KNOWLEDGE marker: create a new wiki page (or extend an existing one) with citations to the experience source.
> 5. For every WIKI GAP: decide whether it warrants a new page, an addition to an existing page, or just an index entry. Justify the decision.
> 6. Update `wiki/index.md`.
> 7. Add backlinks from affected pages to the new/updated content.
> 8. Append a `reconcile` entry to `wiki/log.md` listing every page touched and every contradiction flagged.
>
> Every update must cite the experience source with `[Source: <experience-filename>]`. Never modify `raw/` — the experience source is immutable just like any other source.

## When to use

- After a task retro has been copied into `raw/` (see `prompts/task-retro.md`)
- After a post-mortem
- After any "I tried to follow the docs and reality was different" moment where you've written down what actually happened

## When NOT to use

- For curated reading material (docs, READMEs, articles) — use `prompts/ingest.md` instead
- Before you've actually written down the experience as its own immutable file in `raw/`. Don't reconcile from memory — the audit trail depends on the experience being a real source with a date.
