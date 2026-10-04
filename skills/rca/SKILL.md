---
name: rca
description: Find the root cause of a bug, crash, wrong output, or incident fast, with evidence. Use when the user asks to debug, investigate, find the RCA, or explain why something broke.
---

# Root cause analysis

Find the cause, prove it, then fix it minimally (only if asked to fix).

1. **State the symptom** in one sentence: what happens, what should happen, where.
2. **Reproduce.** Run the smallest command, request, or test that shows the symptom. If you cannot reproduce, say so and gather logs instead.
3. **Gather evidence in one batch.** In a single `codemode` script: grep the error text, read the suspect files, check `git log -p` for recent changes to them, and pull relevant logs. Return only the matching lines.
4. **Form one hypothesis at a time.** Write it down, name the check that would disprove it, and run that check.
5. **Confirm the cause** with a file:line and the evidence that proves it. "Probably" is not a cause; say "not proven" when it is not.
6. **Fix (if asked):** change the shared function every caller routes through, rerun the reproduction, and run the related tests.

Report: cause (file:line), evidence, fix and its verification, and anything still unknown.

Use the `explore` subagent for a wide search only when the code base is too large to grep in one script.
