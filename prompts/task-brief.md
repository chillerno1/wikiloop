# Write a task brief

The brief is the human's judgment about what the task is. The agent does not write this. Write it yourself, by hand, before anything else happens. Five minutes spent here saves hours downstream.

## How to start a new task

```bash
cp -R tasks/_template tasks/$(date +%Y-%m-%d)-<short-slug>
```

Then open `tasks/<date>-<slug>/task.md` and fill it in. Nothing else in that folder should be touched yet — `plan.md`, `execution.md`, `retro.md` are for later steps.

## What a good brief contains

- **Goal** — one paragraph. What done looks like from the outside. Not how, just what.
- **Constraints** — what must or must not happen. Downtime tolerance, deadlines, dependencies, blast radius, reversibility.
- **Acceptance criteria** — the concrete checklist that proves it's done. Written as bullets someone else could verify.
- **Context pointers (optional)** — wiki pages you already know are relevant. If you don't know any, leave this blank and let the plan step discover them.
- **Out of scope (optional)** — things you're deliberately not doing, to prevent scope creep in the plan.

## Anti-patterns to avoid

- **Writing the "how" in the brief.** That's the plan's job. The brief is about *what* and *why*, not *how*.
- **Letting the agent draft the brief.** The agent will produce a plausible-looking brief that encodes none of your actual judgment about constraints and risk. You will then plan, execute, and retro against someone else's framing. Do not do this.
- **Skipping acceptance criteria.** Without them, "done" is a feeling, and retros become arguments about whether the task succeeded.
- **Padding with context the wiki already knows.** If the wiki already has a page on the target system, don't re-explain it in the brief — just name it in context pointers.

## Example

```markdown
# Deploy notifications-service v0.3.0 to production

## Goal
Ship v0.3.0 of notifications-service to the prod cluster so downstream
email-service can start consuming the new batch-send endpoint.

## Constraints
- Zero downtime — email-service calls notifications-service every 90s
- Must coexist with existing v0.2.x during rollout (backwards-compat endpoint)
- Needs to be live before the Friday 09:00 standup
- Rollback must be possible within 5 minutes

## Acceptance criteria
- [ ] v0.3.0 pods healthy in prod for 30 consecutive minutes
- [ ] /metrics endpoint scraped by Prometheus, visible in Grafana
- [ ] Smoke test (POST /v1/notify/batch) returns 200 from prod
- [ ] Rollback rehearsed on staging in the same session
- [ ] Runbook updated if anything new learned during deploy

## Context pointers
- [[notifications-service]]
- [[prod-cluster]]
- [[deploy-runbook]]

## Out of scope
- Deprecating the v0.2.x endpoint (separate task next sprint)
- Dashboard updates
```

Once `task.md` is filled in, move to `prompts/task-plan.md`.
