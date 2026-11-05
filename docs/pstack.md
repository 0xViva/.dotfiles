# pstack on OpenCode

poteto's pstack, vendored at `~/.config/opencode/vendor/cursor-plugins/pstack`, wired into OpenCode by `opencode/opencode.json`.
The adapter is `opencode/pstack-adapter.md`; the role models are `opencode/pstack-models.md`.

## Use it

Type `@poteto-mode` before a task:

```
@poteto-mode this bug drifts every 750ms. repro first, then fix and verify.
```

For one skill, name it directly: `@tdd`, `@interrogate`, `@how`, `@poteto-help`. Plain English ("use the poteto-mode skill") also works, because naming a skill lets OpenCode load it even though pstack hides it from the automatic list.

`@name` is an OpenCode skill mention. It loads that skill's `SKILL.md` into the session.

## Skills

### Start here

| Skill | What it does |
| --- | --- |
| `@poteto-mode` | Main entry point. Picks a playbook, opens a todo list, routes to other skills, keeps replies unslopped and verified. |
| `@poteto-help` | Tells you which skill or playbook fits. |
| `@setup-pstack` | Re-runs the model/role configuration. |

### Understand before changing

| Skill | What it does |
| --- | --- |
| `@how` | Walks through how a subsystem works, before you edit it. |
| `@why` | Finds why something was built that way, from git history, issues, docs, and MCP sources. |
| `@teach` | Runs how plus why and weaves one plain explanation with diagrams. |
| `@sharpen` | Sharpens a vague task into the expert approach before starting. |
| `@in-your-own-words` | Plays back your goal and the problem so you can correct it first. |
| `@ketchup` | Catches you up on what changed since your last message. |
| `@bro` | Restates the last message in plain human language. |
| `@recall` | Rebuilds recent context from chat history. Skipped on OpenCode: no Cursor transcripts. |

### Build and attack a design

| Skill | What it does |
| --- | --- |
| `@architect` | Settles types, signatures, and module shape before code gets written. |
| `@tdd` | Writes the failing test first, then the fix. Use when a cheap local test exists. |
| `@figure-it-out` | Designs a bespoke rigorous plan when no standard playbook fits. |
| `@arena` | Runs N candidates at the same task, picks a base, grafts the best parts of the rest. |
| `@swarm` | Fans out N workers across slices or races, then returns one report. |
| `@interrogate` | Adversarial multi-model review of a diff. |
| `@blast-radius` | Finds what else a small change could break, proven by running code. |

### Prove and record

| Skill | What it does |
| --- | --- |
| `@benchmark-checklist` | Vets a perf number before you trust or report it. |
| `@create-verification-skill` | Generates a project skill that drives the real app to prove behavior. |
| `@maintain-verification-skill` | Keeps that verification skill honest as the app changes. |
| `@create-formal-verification-skill` | Generates a model-checker or proof skill for cases tests cannot reach. |
| `@show-me-your-work` | Keeps a reviewable TSV decision trail for long or unattended runs. |

### Code and writing quality

| Skill | What it does |
| --- | --- |
| `@no-comments` | Spawns Comment Sicko, then fixes accepted comment and workaround findings. |
| `@unslop` | Removes AI tells from writing. |
| `@technical-writing` | Doc standard for docs, RFCs, readmes, PR bodies, and commit messages. |
| `@typescript-best-practices` | TypeScript rules grounded in the type-system-discipline principle. |
| `@reflect` | Captures what a run learned and routes each lesson into a skill edit. |
| `@correct` | Finds repeated agent mistakes in the repo and encodes each fix. Skipped on OpenCode: no Cursor transcripts. |
| `@automate-me` | Drafts a personal `-mode` skill from your working style. Skipped on OpenCode: no Cursor transcripts. |
| `@make-bot-ui` | Builds a page whose buttons wake a Grok bot over a webhook. |

### Principles

24 leaves named `@principle-*`, such as `@principle-laziness-protocol`, `@principle-fix-root-causes`, and `@principle-prove-it-works`.
You rarely invoke these directly. `poteto-mode` points at them by name when a step needs one, and the agent reads the leaf in full.

Not present: `@deslop`, `@control-cli`, `@control-ui`. They ship in `cursor-team-kit`, which is vendored but not loaded.

## How poteto-mode selects skills

It does not scan all 55 skills and choose freely. Its `SKILL.md` contains a fixed set of triggers and a playbook table, and it matches your request against them.

1. It matches the task to a playbook: investigation, bug fix, perf, hillclimb, feature, refactoring, prototype, visual parity, eval, babysit, shipping, autonomous run, orchestrate, and others. If none fits, it routes to `figure-it-out`.
2. It opens a todo list whose first items are the playbook's steps, copied verbatim.
3. As each step fires, a trigger routes to the named skill. Examples: a nontrivial change goes to `how`; parallel fan-out goes to `swarm`; a contested design goes to `interrogate`; docs go to `technical-writing`; before commit it wants `deslop`; prose goes to `unslop`; a bug fix with a cheap test goes to `tdd`.
4. Principles are referenced by name from that trigger list, not by search.

So the pick is deterministic and visible in the skill's own text. OpenCode itself never auto-selects a pstack skill, because every one is marked `disable-model-invocation: true`. Loading `@poteto-mode` starts the routing.

A skill outside that graph is used only when you name it, like `@tdd`.
