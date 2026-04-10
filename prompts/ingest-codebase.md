# Ingest a codebase

Codebases are not sources in the Karpathy sense — they're the *things* that sources describe. Dropping raw code files into `raw/` produces a shallow, token-hungry wiki with broken citations. The right pattern is a two-step process: produce a structured markdown summary of the codebase first, then ingest the summary as a normal source.

## Why the two-step pattern

1. **Source files describe nothing; they *are* the thing.** An LLM ingesting code has to interpret it *and* write the wiki in one pass, and does both worse.
2. **Token cost.** A mid-size repo is easily 200K+ tokens. The whole point of the wiki is that it's a compressed, structured representation.
3. **Signal-to-noise.** Most of a codebase is boilerplate, imports, and generated files. The wiki should be built from the interesting 5% — architecture, invariants, non-obvious decisions.
4. **Citation integrity.** A wiki claim cited to `src/services/billing.py` is useless — which version, which commit? A claim cited to `codebase-billing-service-2026-04-10.md` is actionable.
5. **Staleness.** A wiki ingested from code is wrong the moment someone commits. A wiki ingested from a *summary of* the code stays accurate as long as the architectural shape doesn't change — much slower drift.

## Step 1 — Produce a structured summary

Open the codebase in the same agent you'll use to query the wiki (this matters — using a different tool for summarization creates subtle inconsistencies that surface as contradictions later). Paste this prompt:

> You are producing a structured summary of this codebase, to be ingested into a markdown knowledge base. Walk the directory tree, read the important files, and produce a single markdown file at `<VAULT>/raw/codebase-<name>-<YYYY-MM-DD>.md` using exactly the template below. Do not invent information. If a section cannot be filled in from the code, write "Unknown — not evident from the code" and move on.
>
> ```markdown
> # <Service / project name>
>
> ## Purpose
> One paragraph. What this exists to do, in business terms, not technical ones.
>
> ## Architecture
> - Language / framework / runtime
> - Entry points (where does execution start)
> - Key directories and what lives in each
> - Main external dependencies and why each is used
>
> ## Core concepts and domain model
> - Each entity / concept the code deals with, one paragraph per concept.
> - Relationships between entities.
>
> ## Key flows
> - For each important user-facing or system-facing operation, a numbered
>   step-by-step of what happens in the code. Name the functions / files involved.
>
> ## Invariants and assumptions
> - Things the code assumes to be true that aren't enforced by types.
> - Places where "the obvious thing" would be wrong.
>
> ## Non-obvious decisions
> - Design choices that look weird but were intentional.
> - Anywhere you'd say "wait, why is it done this way?" — include the answer
>   if you can find it in comments, commit messages, or naming.
>
> ## External surface
> - Public APIs, CLI commands, environment variables, config files.
> - What other systems consume this or are consumed by it.
>
> ## Known gaps and smells
> - TODOs, FIXMEs, dead code, commented-out blocks.
> - Parts that look incomplete or inconsistent.
>
> ## Files to read to understand this codebase
> - Ordered list of 5–10 files a new engineer should read first, one line on why each matters.
> ```
>
> After writing the summary, stop and tell me the path to the file. Do not ingest it yet.

The structured template is the quality lever. A freeform "summarize this repo" prompt produces generic output and a shallow wiki. The template forces the agent to look for specific things.

## Step 2 — Review the summary

The summary is about to become an immutable source. Whatever errors it contains will propagate into the wiki and become "true." Ten minutes of editing here saves a month of confused queries later.

Open `raw/codebase-<name>-<date>.md` and check:

- **Purpose:** did it capture what the code *does for the business*, or did it fall back to a technical description? If it says "a Python service that exposes REST endpoints" instead of "the billing engine that turns usage events into invoices," rewrite it yourself.
- **Architecture:** are the listed dependencies real? LLMs occasionally hallucinate plausible-looking imports. Spot-check against `package.json` / `pyproject.toml` / `Cargo.toml`.
- **Key flows:** did it miss an important one? If your mental model of the codebase has 5 main flows and the summary lists 3, add the missing ones.
- **Invariants:** this is the hardest section and the most valuable. LLMs under-index on invariants because they're invisible in the code. Add any you know of yourself.
- **Non-obvious decisions:** same. If there's a weird pattern you know the history of, write it down. This is often tribal knowledge worth more than the rest of the file combined.
- **Known gaps:** make sure it didn't paper over anything. TODOs are signal, not noise.

Edit the file directly. Once it's good, treat it as immutable going forward.

## Step 3 — Ingest the summary

Run the normal ingest workflow on the summary file:

> Read `prompts/ingest.md` and process `codebase-<name>-<YYYY-MM-DD>.md` from `raw/`.

The agent treats it like any other source — extracts entities and concepts, creates 10–15 wiki pages (one for the service itself, one per major concept, one per flow, etc.), adds citations. From here, the normal loop applies: the service's pages can be linked from retros, contradicted by reconciliations, and used by future task plans.

## Re-summarizing as the code changes

The summary is a snapshot. Guidance on when to refresh:

- **Minor changes (bug fixes, small features):** don't re-summarize. Capture them as short notes in `raw/` or as retros if they came out of a task. Reconcile them into the existing wiki pages with `> CONTRADICTION:` callouts where needed.
- **Structural changes (new major component, significant refactor, changed data model):** produce a new summary file with a new date — e.g. `codebase-<name>-2026-08-15.md`. Ingest it as a reconciliation source using `prompts/reconcile.md`. Let contradictions flag the changes so the history is preserved.
- **Never delete the old summary.** It's the historical record of what the codebase looked like at a point in time. Contradictions between old and new summaries are exactly the kind of signal worth keeping.

## Variants

**For a repo you own:** commit the summary into the repo itself as `docs/codebase-summary.md`. Now it doubles as onboarding material. Copy it into `raw/` to ingest.

**For a repo you don't own (dependency, library, vendor code):** summarize only the parts you interact with, not the whole thing. A summary of "how my code uses lodash" beats a summary of lodash itself.

**For a large monorepo:** one summary per logical subsystem, not one for the whole thing. Name them `codebase-<repo>-<subsystem>-<date>.md`. The wiki will naturally cross-reference where subsystems interact.

**For code you're about to change:** summarize *before* the change, execute the task, then retro. Contradictions between the pre-change summary and the retro reveal where your mental model of the code diverges from reality — often the most valuable insight the loop produces.
