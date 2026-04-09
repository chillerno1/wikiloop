# Ingest multiple sources in one go

Use this when you want to ingest several sources sequentially in a single message, while keeping the per-source discussion and provenance of the normal ingest workflow.

## Prompt

> Ingest the following files from `raw/`, in order, using the workflow in `prompts/ingest.md`. For each source: read it fully, discuss takeaways with me and wait for confirmation, then write the wiki updates before moving to the next source. Do not batch the writes across sources — each source gets its own full ingest cycle with its own `[Source: ...]` citations and its own log entry.
>
> Sources:
> 1. `<filename-1.md>`
> 2. `<filename-2.md>`
> 3. `<filename-3.md>`

## When to use

- You have 2–5 related sources and want one message instead of three.
- Order matters — e.g. ingest the architecture doc before the case files so later pages can link back to it.
- You still want the discussion/confirmation step for each source (that's the main reason to prefer this over a fully automated batch).

## When NOT to use

- More than ~5 sources at once — context gets crowded and discussion quality drops. Split into multiple sessions.
- Sources you haven't read yourself at all. At least skim each one first so you can tell when the agent's takeaways are off.
- High-stakes sources where you'd want to review each wiki diff before the next ingest starts.
