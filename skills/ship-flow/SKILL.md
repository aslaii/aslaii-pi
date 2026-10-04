---
name: ship-flow
description: Build a feature in gated phases (backend, API wiring, UI) with one commit per phase and a resumable plan file. Use for full-stack features, multi-step changes, or when the user says /ship or asks to continue a plan.
---

# Ship flow

One plan file, a few phases, one commit per phase. The plan file is the only state; anyone can resume from it.

## 1. Plan (one short pass)

Read the code the feature touches, then write `.pi/plans/<slug>.md`:

```markdown
# <feature>
Goal: <one sentence the user would agree with>

- [ ] 1 Backend: <endpoints / logic>. Gate: <curl commands and expected status/body>
- [ ] 2 Wiring: <API client, buttons, calls>. Gate: <the call works from the app>
- [ ] 3 UI: <screens and states>. Gate: <what the page must show>

Notes:
```

Skip phases that do not apply. Keep each phase small enough for one sitting. If a decision would change the work materially, ask once, then continue.

## 2. Execute each phase

1. Implement only that phase.
2. Run its gate for real: curl the endpoint, click the button, load the page. Run the repo's existing tests for the files you touched.
3. If the gate fails, fix and rerun. After two identical failures, stop and ask.
4. Commit the phase (use the `commit` subagent when available), tick its box, and add one line under Notes with the evidence (command and result).

Never start a phase while the previous gate is red.

## 3. Resume

If a plan file exists, read it and `git log --oneline -10`, then continue at the first unticked box. Do not redo ticked phases.

## 4. Finish

When every box is ticked, report: what shipped, the gate evidence per phase, and anything not verified.

## Parallel work

Use subagents only when parts of one phase are truly independent (for example three unrelated endpoints). Give each one a disjoint set of files. Run them in parallel, then check each result yourself before the gate.
