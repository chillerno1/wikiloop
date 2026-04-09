# Operational KB

An extension of the Karpathy-style personal knowledge base method, designed for **operational work** — not just research. The vault isn't just memory; it's the control plane for how work happens. The wiki proposes, you execute, the wiki learns.

Plain markdown, plain folders, one bash script. No database, no embeddings, no vector store. Works with any agent that can read and write files in a directory.

## Background

Andrej Karpathy's personal knowledge base method treats a folder of markdown files as a second brain: you drop sources into `raw/`, an LLM compiles a cross-referenced `wiki/` with citations, and future questions get answered by reading the wiki instead of the raw sources. Knowledge compounds instead of resetting every conversation.

That method is **read-optimized**: ingest sources, build wiki, query wiki, get answers. Great for research.

This project adds a fourth directory — `tasks/` — and a loop that turns knowledge into action and action back into knowledge. The wiki doesn't just accumulate what you've read; it accumulates what you've *done*, and what reality taught you when the docs were wrong.

## The operational loop

```
  ┌────────────────────────────────────────────────────┐
  │                                                    │
  │   brief  ──►  plan  ──►  execute  ──►  retro       │
  │    │           │           │            │          │
  │    │           │           │            ▼          │
  │    │           │           │       reconcile ──┐   │
  │    │           │           │                   │   │
  │    ▼           ▼           ▼                   ▼   │
  │  tasks/    wiki/ (read)  tasks/             raw/   │
  │                                                    │
  │                      ▲                             │
  │                      │                             │
  │                      └──── wiki updates ───────────┘
  │                                                    │
  └────────────────────────────────────────────────────┘
```

1. **Brief** — you write `task.md` by hand. What you're trying to do, constraints, acceptance criteria. The agent does not write this.
2. **Plan** — the agent reads the wiki and your brief, produces `plan.md` with every step cited to a wiki page. Gaps are flagged explicitly (`NO WIKI BASIS`).
3. **Execute** — you and the agent pair on the actual work, logging as you go into `execution.md`. Every time reality diverges from the plan, it's flagged inline (`WIKI GAP`, `CONTRADICTS WIKI`, `NEW KNOWLEDGE`).
4. **Retro** — the agent reads the brief, plan, and execution log, writes `retro.md` — what went as planned, what didn't, what the wiki got wrong, what it didn't know.
5. **Reconcile** — the retro is copied into `raw/` as an immutable experience source, then ingested back into the wiki with `> CONTRADICTION:` callouts preserving history. The wiki has now learned.

Next task, the plan is better because the wiki is smarter. This is the compounding mechanism: not just breadth of knowledge, but accuracy of knowledge, pressure-tested by reality.

## Why this works

Most documentation systems — wikis, Confluence spaces, README trees — decay because corrections live in people's heads, not in the docs. Someone runs into a gap, figures it out, solves their problem, and moves on. The next person hits the same gap. This is the single biggest form of institutional knowledge loss.

The operational loop closes that leak. Every execution produces a retro. Every retro becomes an immutable source. Every source feeds back into the wiki with full provenance and contradictions preserved. The wiki gets monotonically better at describing reality, because every time reality contradicts it, the contradiction is captured and filed.

Three properties make this work:

1. **Citations are mandatory.** Every claim in the wiki traces to a specific source. When two sources disagree, both are preserved in a `> CONTRADICTION:` callout, so you always know *why* a claim exists and *when* it was last challenged.
2. **Experience is a first-class source.** Retros live in `raw/` alongside curated reading material. They're dated, immutable, and cited just like any other source.
3. **The human writes the brief.** The agent doesn't decide what the task is. It plans, pairs, scribes, and proposes — but the judgment about *what* to do and *whether* the result is acceptable stays with the human.

## Quick start

```bash
git clone <this-repo> kb-skeleton
cd kb-skeleton
./spawn.sh ~/my-vault "what this KB is about" "focus area 1" "focus area 2" "focus area 3"
```

This creates a new vault with the full directory structure, a filled-in `CLAUDE.md`, the prompt library, a task template, an initial `wiki/log.md`, and a fresh git repo.

From there:

```bash
cd ~/my-vault
```

Open it in an AI coding assistant that can read and write files in the directory. Drop your first source into `raw/` and point the agent at `prompts/ingest.md`. Once the wiki has enough content to be useful (5–10 sources), start your first task:

```bash
cp -R tasks/_template tasks/$(date +%Y-%m-%d)-<slug>
```

Then walk through `prompts/task-brief.md` → `prompts/task-plan.md` → `prompts/task-execute.md` → `prompts/task-retro.md`.

## Structure

```
kb-skeleton/
├── README.md                     this file
├── CLAUDE.md.template            schema with task workflow, privacy rules, reconcile loop
├── spawn.sh                      creates a new self-contained vault
├── prompts/
│   ├── ingest.md                 single-source ingest
│   ├── ingest-multiple.md        sequential multi-source ingest
│   ├── query.md                  grounded question answering
│   ├── explore.md                surface unexplored connections
│   ├── brief.md                  generate a structured briefing from the wiki
│   ├── lint.md                   health check for contradictions, staleness, orphans
│   ├── reconcile.md              experience-based correction ingest
│   ├── task-brief.md             how to write the human-authored task.md
│   ├── task-plan.md              generate a cited plan from the wiki
│   ├── task-execute.md           structured execution log + agent pairing
│   └── task-retro.md             retro + reconcile back into the wiki
└── tasks/
    └── _template/                copy this folder to start any new task
        ├── task.md
        ├── plan.md
        ├── execution.md
        ├── retro.md
        └── artifacts/
```

A spawned vault looks like:

```
~/my-vault/
├── CLAUDE.md                 schema with your topic + focus areas filled in
├── raw/assets/
├── wiki/
│   ├── index.md              the map — agent reads this first for every query
│   └── log.md                append-only history of ingests, plans, retros
├── outputs/                  saved briefings and analyses
├── tasks/
│   └── _template/
└── prompts/                  copied from the skeleton at spawn time
```

Each spawned vault is fully self-contained. `spawn.sh` copies prompts into the vault rather than symlinking, so you can move vaults around, hand them off, or run them in environments that don't support symlinks.

## What's different from a vanilla research KB

| | Research KB | Operational KB |
|---|---|---|
| Directories | `raw/ wiki/ outputs/` | + `tasks/` |
| Agent's role | Librarian | Librarian + pair partner + scribe |
| Primary loop | ingest → query | brief → plan → execute → retro → reconcile |
| Schema includes | ingest / query / lint workflows | + task workflow + privacy rules |
| Source types | Curated reading material | Reading material + captured experience |
| Compounding | Breadth of knowledge | Breadth *and* accuracy |

The research mode still works exactly as before. You can ingest and query without ever touching `tasks/`. The operational loop is additive — use it when you have work to do, skip it when you're just exploring.

## Privacy and safety

`CLAUDE.md.template` includes a privacy section that instructs the agent to never fabricate details, never write anything the human didn't provide, never commit secrets, and flag staleness aggressively. This matters more for operational KBs than research KBs because the sources often include real systems, real people, and real credentials-adjacent information. Adjust the privacy section to match the sensitivity of your domain before ingesting real content.

## Honest caveats

- **The loop requires discipline.** Skipping retros for two weeks breaks the compounding. The method only works if every task ends with a retro, even a sloppy three-bullet one.
- **The wiki is one agent's interpretation.** It can be wrong, and confident wrongness at scale is the biggest failure mode. The monthly lint workflow exists to catch this; use it.
- **Context windows are real.** The method works best up to a few hundred pages per vault. Beyond that, the agent can't reliably hold the whole wiki in mind and will miss connections. Keep one domain per vault.
- **This isn't agent autonomy.** The agent plans, pairs, and scribes. You still execute the work, especially anything touching production or shared systems. The value is in the loop, not in delegation.
- **Markdown is the feature.** No database, no vector store, no indexing service. If you find yourself wanting to add one, you're probably past the size where this method is the right fit.

## Credit

Based on Andrej Karpathy's April 2026 gist on LLM-maintained personal knowledge bases. The operational loop (tasks, retros, reconciliation) is an extension of that method.

## License

MIT.
