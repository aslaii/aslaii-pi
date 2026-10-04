# aslaii-pi

A lean setup for [Pi](https://github.com/earendil-works/pi), the minimal coding agent. It is a Pi package, not a fork: Pi stays upstream and this repo adds a small set of rules, skills, commands, and subagents on top.

The idea is simple. A strong model does not need a heavy harness around it. It needs few turns, small context, the right model for each job, and a real check before it says "done".

## What you get

- **Codemode on by default.** The model writes one JavaScript script that calls tools in parallel and filters their output, instead of many separate tool calls.
- **Short working rules** (`APPEND_SYSTEM.md`): smallest correct change, batch reads, verify once by running the real thing, plain language, stop when done.
- **`/ship`** runs the `ship-flow` skill: a short plan file with gated phases (backend, API wiring, UI), one commit per phase, and resume from the first unticked box.
- **`/rca`** runs the `rca` skill: reproduce, gather evidence in one batch, one hypothesis at a time, cause with `file:line`.
- **Subagents across model families** (via [pi-subagents](https://github.com/nicobailon/pi-subagents)):

| Agent | Job | Default model |
|---|---|---|
| `commit` | Commit finished work in the repo's style | GPT Luna |
| `explore` | Read-only code search | GPT Sol |
| `task` | One isolated implementation slice | GPT Sol |
| `review` | Second opinion from another family | Claude Opus |
| `quick` | Small mechanical chores | GLM (open weights) |

No single model is best at everything, so each role picks its own.

## Install

Requires Node 22+.

```bash
npm install -g @earendil-works/pi-coding-agent
git clone https://github.com/aslaii/aslaii-pi.git
aslaii-pi/setup.sh
```

`setup.sh` installs `pi-subagents`, installs this package from your clone, turns on codemode, and links `APPEND_SYSTEM.md` into `~/.pi/agent/`. An existing `APPEND_SYSTEM.md` is moved to `APPEND_SYSTEM.md.bak`. Because the package is installed from a local path, edits in your clone apply on the next Pi start.

If another tool also installs a `pi` binary, point the script at the right one with `PI_BIN=/path/to/pi ./setup.sh`, and give vanilla Pi its own alias, for example `alias aslaii-pi=/path/to/pi`.

Then start `pi` and run `/login` for each provider you use (ChatGPT, Claude, OpenCode).

## Change the models

Model IDs depend on the providers you are logged in to. List them with `pi --list-models`, then either edit the `model:` line in `agents/*.md` or override one role in `~/.pi/agent/settings.json`:

```json
{
  "subagents": {
    "agentOverrides": {
      "commit": { "model": "anthropic/claude-haiku-4-5" }
    }
  }
}
```

A subagent uses exactly one model per run. If that provider is down or out of quota, the run fails rather than silently switching.

## Layout

```
APPEND_SYSTEM.md   working rules added to Pi's system prompt
agents/            subagent definitions (model, tools, prompt)
prompts/           /ship and /rca commands
skills/            ship-flow and rca
setup.sh           one-time install
```

## License

MIT
