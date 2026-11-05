# pstack in OpenCode

pstack is installed at `~/.config/opencode/vendor/cursor-plugins/pstack`. Call that `<pstack>`. Its skills use Cursor names. Read this file once per session, then map each name below before acting. If a Cursor field has no row, drop it and say so. Never pass a field or value that OpenCode rejects.

## Skills

- pstack skills are registered but hidden from the model's skill list. Load one with the `skill` tool using its exact ID. The user can load one by mentioning `@<id>`.
- A `/name` in a skill, or "the **name** skill", means the pstack skill `name`. Load it with the `skill` tool. If the tool refuses, read `<pstack>/skills/<name>/SKILL.md` and follow it. When telling the user to invoke it, write `@name`.
- Supporting files resolve from the skill that names them: `<pstack>/skills/<name>/playbooks/...`, `<pstack>/skills/<name>/references/...`, and principle leaves at `<pstack>/skills/principle-<title>/SKILL.md`.

## Tools

| Cursor | OpenCode |
| --- | --- |
| `Task` | `subagent` |
| `AskQuestion` | `question` |
| Open a todolist | `todowrite` |
| `run_in_background: true` | `background: true` |
| `readonly: true` | `agent: "explore"` |
| `Grep`, `Glob` | `grep`, `glob` |

## Subagents

| Cursor | OpenCode |
| --- | --- |
| `subagent_type: "poteto-agent"` | `agent: "poteto-agent"` |
| `subagent_type: "comment-sicko"` | `agent: "comment-sicko"` |
| `generalPurpose` | `general` |
| `environment: "cloud"` | Start the child in a worktree and name the branch or commit in its prompt. |
| `environment: "local"` | Omit. |
| `resume` | Spawn a fresh subagent with the consolidated brief. Use `sessionID` only when the work needs that session's live state. |
| `file_attachments` | List the paths in the prompt. |

A role's model goes in the `subagent` tool's `model` field. Do not invent an agent for a role. The two pstack agents live in `~/.config/opencode/agents/`, and their prompts already point at `<pstack>`.

## Models

OpenCode model references are `provider/model#variant`. Except where the table below overrides it, map a Cursor slug by replacing the version-effort suffix with `#effort`, keep the slug's family, and drop a trailing `-fast` because OpenCode has no fast variant. A role line repeated in a panel list is intentional: each entry is one independent attempt, so the fan-out count does not change when every entry uses the same model.

| Cursor slug | OpenCode |
| --- | --- |
| `claude-opus-5-5-xhigh` | `opencode-go/deepseek-v4.1-flash#high` (this machine's only pstack model) |
| `grok-4.7-xhigh-fast` | `opencode-go/deepseek-v4.1-flash#high` |
| `auto`, `inherit-parent` | omit `model` |

The role table is `~/.config/opencode/pstack-models.md`, loaded as an instruction. If the file or a role's line is missing, use the skill's default. Pass the role's reference as `model` to `subagent`.

## setup-pstack

Follow the skill with these changes.

- Detect. Run `opencode api get /api/model` and read `.data[]` as `providerID/modelID`, plus each `.variants[].id` as the `#variant` suffix. A model with no variants is used bare.
- Defaults. This machine uses one model for every role: `opencode-go/deepseek-v4.1-flash#high`. Map both of the skill's default slugs to it, including the panel entries.
- Budget. Apply the budget to the variant. Use the nearest variant at or below the target when the model lacks it, as the skill's step 3b says. `deepseek-v4.1-flash` has `low`, `high`, and `max`, so `xhigh` becomes `high`.
- Write `~/.config/opencode/pstack-models.md`, never `~/.cursor/rules/pstack-models.mdc`. Overwrite the whole file, with no frontmatter: the comment lines, the `# budget` line, then one line per role.
- Never write role lines into `AGENTS.md`.

## Paths

| Cursor | OpenCode |
| --- | --- |
| `.cursor/skills/`, `~/.cursor/skills/` | `.opencode/skills/`, `~/.config/opencode/skills/` |
| `.cursor/rules/*.mdc`, always-applied rules | an `instructions` entry in `opencode.json` |
| `https://github.com/cursor/plugins/blob/main/pstack/<path>` | `<pstack>/<path>`: read the local copy |

## Cursor-only features

OpenCode has no Cursor Automations, Bugbot, cloud agents, `/loop`, or built-in PR tool. The `cursor-team-kit` skills (`deslop`, `control-cli`, `control-ui`) are not installed, so skip a step that requires one. When a step needs one, write one line, `Skipped in OpenCode: <step>. <reason>.`, and continue. Do not stop or retry. For a PR, use the forge command the step already names, such as `gh pr create`. Transcript-mining steps (`recall`, `correct`, `automate-me`) read a Cursor transcript directory that OpenCode does not write. Skip them with that line and say what the user must paste instead.
