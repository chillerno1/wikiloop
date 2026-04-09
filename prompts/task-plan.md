# Generate a plan from the wiki

The plan is produced by the agent, **grounded in the wiki**, with every step cited. Steps that have no wiki basis are flagged as gaps — those are the riskiest parts of the task and the places where the KB will learn the most.

## Prompt

> Read `CLAUDE.md` and `tasks/<date>-<slug>/task.md`. Then read `wiki/index.md` and every wiki page relevant to this task — follow links, be thorough, read broadly.
>
> Produce `tasks/<date>-<slug>/plan.md` with the following structure:
>
> 1. **Summary** — one paragraph restating the goal in your own words, to confirm you understood the brief.
> 2. **Relevant wiki pages** — bullet list of every wiki page you consulted. If you didn't consult any, say so explicitly.
> 3. **Pre-flight checks** — things to verify before touching anything. Each with a citation.
> 4. **Steps** — numbered, in execution order. Each step must:
>    - State the action
>    - Cite the wiki page(s) it is based on: `[Source: page-name]`
>    - If no wiki page supports this step, flag it: `> NO WIKI BASIS — verify manually before executing. Reason: <why this step is necessary anyway>`
>    - Include the rollback or undo action for this step where applicable
> 5. **Top 3 risks** — what's most likely to go wrong, cited to wiki pages where possible. For each, name the wiki page where the mitigation would live (even if the page doesn't exist yet — that's a gap worth flagging).
> 6. **Wiki pages likely to need updating** — if execution reveals any of these steps to be wrong, which pages would need correction in the retro? List them explicitly.
>
> Do not pad with generic best practices. Every claim must come from the wiki or be explicitly flagged as not from the wiki. If the wiki is thin on this topic, say so — do not compensate by inventing plausible steps.
>
> After writing the plan, append a `plan` entry to `wiki/log.md`: `## [YYYY-MM-DD] plan | <slug> — <one-line description>. Steps: <N>. NO WIKI BASIS steps: <N>. Relevant pages: <list>.`
>
> Then stop and wait for me to review. Do not begin execution.

## What good looks like

A plan that is 60% cited and 40% flagged as NO WIKI BASIS is **not a bad plan** — it's an honest plan that tells you exactly where your documentation is weakest. That's the whole point. A plan that's 100% cited might be a better-documented task *or* it might be an agent that hallucinated citations. Spot-check a few.

## What to do after reviewing

- **Citations look wrong?** Open the cited wiki page and read it yourself. If the page says something different from what the plan claims, that's a bug — tell the agent to re-read and re-cite.
- **Too many NO WIKI BASIS steps?** Consider ingesting another source before executing. You may have a gap you can fill in 10 minutes with the right doc.
- **Plan looks right?** Proceed to `prompts/task-execute.md`.
