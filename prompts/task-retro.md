# Retro and reconcile

The retro closes the loop. Without it, the wiki doesn't learn, the compounding effect collapses, and the KB devolves back into a research brain. This is the single most important ten minutes of the whole task workflow.

## Step 1 — Write the retro

> Read `CLAUDE.md`, `tasks/<date>-<slug>/task.md`, `tasks/<date>-<slug>/plan.md`, and `tasks/<date>-<slug>/execution.md`. Write `tasks/<date>-<slug>/retro.md` with the following sections:
>
> 1. **Outcome** — success / paused / abandoned / cancelled, and one paragraph of why.
> 2. **What went as planned** — bullet list of steps that executed cleanly without any flags.
> 3. **Where reality diverged** — bullet list of every step that didn't match the plan, with what actually happened.
> 4. **Wiki gaps discovered** — every WIKI GAP marker from the execution log, with the actual answer reality provided.
> 5. **Contradictions with existing wiki content** — every CONTRADICTS WIKI marker, with the correction.
> 6. **New knowledge worth capturing** — every NEW KNOWLEDGE marker, phrased as a claim that could live on a wiki page.
> 7. **Proposed wiki updates** — for each existing page that needs correction, name the page and describe the change. Do not apply the changes yet.
> 8. **Proposed new wiki pages** — for each genuinely new concept, name the page and describe what it would contain.
> 9. **Meta** — anything about the *task workflow itself* that didn't work (was the plan format wrong? was the brief missing something?). These meta-observations inform prompt improvements, not wiki updates.
>
> Do not touch `wiki/` during this step. The retro is a proposal, not an execution. Do not copy anything to `raw/` yet.

## Step 2 — Human review

Read the retro. For each proposed wiki change and each proposed new page:

- **Approve** — the change is correct and should be reconciled into the wiki
- **Reject** — the change is wrong, misleading, or not worth capturing
- **Amend** — the change is mostly right but needs tweaking before reconciling

Annotate the retro file directly with `APPROVED`, `REJECTED`, or `AMENDED: <corrected version>` next to each proposal. Save.

This review step is where your judgment matters most. The agent will happily propose updates that are technically supported by the execution log but are actually one-off quirks that shouldn't become "truth" in the wiki. Reject those. Conversely, the agent will sometimes miss a subtle NEW KNOWLEDGE item because it didn't realize the implication — add those manually.

## Step 3 — Copy retro to raw/

Once the retro is reviewed and approved:

```bash
cp tasks/<date>-<slug>/retro.md raw/retro-<slug>-<date>.md
```

The retro is now an immutable source. It will never be edited again. It becomes part of the permanent record of "what this KB learned from experience."

## Step 4 — Reconcile

Run the reconciliation ingest on the new experience source:

> Read `prompts/reconcile.md`. Process `raw/retro-<slug>-<date>.md` as a reconciliation source. Apply only the changes marked APPROVED or AMENDED in the retro — skip anything marked REJECTED. Preserve history with `> CONTRADICTION:` callouts on every contradicted claim. Create new pages for NEW KNOWLEDGE items. Update `wiki/index.md`. Append a `reconcile` entry to `wiki/log.md`.

## Step 5 — Archive the task (optional)

```bash
mv tasks/<date>-<slug> tasks/archive/
```

Or leave it in place. The task folder remains as the audit trail of what happened, independent of whether the wiki has absorbed the lessons.

## Why the retro matters more than it feels like it should

Every time you skip a retro, you're telling the KB "reality didn't teach me anything this time." That's almost never true, and even when it is, writing a 3-bullet retro that says "nothing learned, the wiki was right" is still valuable — it's a positive confirmation that the wiki's claims held up under execution, which should increase your trust in them.

The compounding comes from doing this *every time*, not from doing it perfectly. A sloppy retro is infinitely better than no retro.
