# Execute with the agent as pair partner

Execution is the only step where the agent and human are both actively working in real time. The agent helps you do the steps, runs commands when appropriate, checks outputs, writes artifacts, and — most importantly — logs what actually happens as it happens. Live logging is the non-negotiable discipline that makes the retro useful.

## Prompt (paste at the start of an execution session)

> Read `CLAUDE.md`, `tasks/<date>-<slug>/task.md`, and `tasks/<date>-<slug>/plan.md`. We are now executing this plan together. You are my pair partner and scribe.
>
> Your responsibilities during execution:
>
> 1. **Run steps with me, not for me.** For each step in the plan: state the step, state the exact command or action, wait for me to confirm before running anything that touches shared systems. For read-only or local actions you may proceed and report the result. For anything that mutates production, staging, or shared infrastructure, always pause and ask.
> 2. **Log live to `tasks/<date>-<slug>/execution.md`** after every step, in this format:
>    ```
>    ## <HH:MM> — <step description>
>    <what was attempted>
>    → <what happened>
>    → <decision or next action>
>    ```
> 3. **Flag divergences inline** in the log, using these markers:
>    - `> WIKI GAP: <what the wiki did not know>`
>    - `> CONTRADICTS WIKI: <page>: <what the wiki said vs. what is true>`
>    - `> NEW KNOWLEDGE: <something learned that should be captured>`
> 4. **Save artifacts** produced during execution (manifests, diffs, configs, screenshots, command outputs worth preserving) to `tasks/<date>-<slug>/artifacts/` with descriptive filenames. Reference them from the execution log.
> 5. **Never edit `wiki/` during execution.** The wiki is read-only in this phase. All corrections wait for the retro and reconcile steps.
> 6. **If the plan is wrong mid-execution,** stop, tell me, and propose an amended step. Do not silently deviate.
> 7. **If you notice I'm about to do something risky that the wiki warns against,** stop me and cite the warning.
>
> Begin with step 1 of the plan. Confirm you have read the task, plan, and relevant wiki pages before we start.

## Human discipline during execution

The agent is a scribe, not a replacement for your judgment. While executing:

- **Stay in the log.** Every meaningful thing you do, even outside the agent's direct involvement, gets added to `execution.md`. Yes, even the "I tried a thing out of curiosity" detours — those are often where the best NEW KNOWLEDGE lives.
- **Flag gut feelings.** If something *feels* wrong even though the plan says it's fine, write that down as a WIKI GAP. Gut feelings are tribal knowledge that hasn't been documented yet.
- **Do not skip ahead on the log after the fact.** Logging live is the whole point. Reconstructing the log from memory at the end destroys the signal.
- **Capture command outputs that matter.** If a command output would be useful in the retro ("oh that error message was weird"), save it to `artifacts/`.

## When execution ends

Execution ends when any of these is true:
- Acceptance criteria are met → success
- A blocker is hit that can't be resolved in this session → paused
- The plan is clearly wrong and needs regeneration → abandoned
- You decided the task isn't worth finishing → cancelled

In all four cases, append a final `## <HH:MM> — end of session` entry to `execution.md` stating which outcome and why. Then append an `execute` entry to `wiki/log.md`:

```
## [YYYY-MM-DD] execute | <slug> — <outcome: success | paused | abandoned | cancelled>. Wiki gaps: <N>. Contradictions: <N>. New knowledge items: <N>.
```

Then move to `prompts/task-retro.md`. Do not skip the retro, even if the task succeeded cleanly — especially if it succeeded cleanly, since that means the wiki was right and you want to confirm that explicitly.
