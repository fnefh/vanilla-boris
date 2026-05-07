---
name: verify
description: Run this project's verification path — the command(s) that prove a change actually works (tests, type-check, browser check, BQ query, computer-use). Use after any non-trivial edit, before declaring "done", and as the gate inside /go. Pairs with hooks/Stop.sh.
disable-model-invocation: true
allowed-tools: Read Bash(bun *) Bash(npm test*) Bash(pnpm test*) Bash(yarn test*) Bash(make *) Bash(pytest *) Bash(go test *) Bash(cargo test *) Bash(curl -s localhost:*)
paths:
  - "**/*.test.*"
  - "**/*.spec.*"
  - "tests/**"
  - "__tests__/**"
  - "spec/**"
hooks:
  Stop:
    - type: command
      command: |
        if [[ "${CLAUDE_SESSION_VERIFY_INVOKED:-0}" -eq 0 ]] \
           && [[ "${CLAUDE_SESSION_EDIT_COUNT:-0}" -gt 0 ]]; then
          echo "[verify skill] this skill is loaded — run /verify before stop"
        fi
      once: false
context: fork
agent: verifier
---

> **Reconstruction notice.** Boris calls the verification loop his #1
> principle ("2–3× quality multiplier") on howborisusesclaudecode.com but
> did not publish a `/verify` skill. This is our reconstruction.

## Verify command for this project
- Declared in CLAUDE.md? !`grep -A1 -i 'verif\|how to verify\|run / test' CLAUDE.md 2>/dev/null || echo "(not declared)"`
- `package.json` test/typecheck scripts: !`test -f package.json && jq -r '.scripts // {} | to_entries[] | select(.key | test("test|typecheck|lint|check")) | "\(.key): \(.value)"' package.json 2>/dev/null || echo "(no package.json)"`
- `Makefile` targets: !`test -f Makefile && grep -E '^[a-zA-Z_-]+:' Makefile | head -10 || echo "(no Makefile)"`

## Instructions

Boris's site Part: **"give Claude a way to verify its work"**. The
verification loop is domain-specific:

- **Backend** — test runner + a synthetic request via `curl` or the test
  client.
- **Frontend** — build, then a browser check (Chrome extension MCP if
  available, otherwise a screenshot via `playwright` / Puppeteer / the
  Desktop app).
- **CLI / library** — type-check + targeted test + one end-to-end
  invocation against a real fixture.
- **Data / analytics** — a `bq` query or equivalent that returns a known
  shape; diff against a fixture.
- **Desktop app** — computer-use to drive the UI.

Workflow:

1. If CLAUDE.md declares a verify command, run *that* (verbatim).
2. Otherwise, infer the smallest credible verify command from the snapshot
   above and ask the user to confirm before running.
3. Run it. Read the output. **Do not** declare success based on "the
   command exited 0" alone — confirm the output matches the change.
4. If verification fails, do **not** patch the test to make it pass.
   Re-plan (see `skills/plan-first`).
5. After verification passes, summarize: command, exit code, the one or
   two output lines that actually prove the change works.

This skill exists to break the failure mode where Claude declares "done"
based on its own narration. Verification beats narration.

## Auto-activation

The `paths:` frontmatter field above auto-loads this skill whenever the
user is editing test files (`*.test.*`, `*.spec.*`, anything under
`tests/`, `__tests__/`, or `spec/`). The skill is also user-invokable as
`/verify` and is wired into the `verifier` agent's `preloadSkills`.

The on-demand `Stop` hook in the frontmatter is session-scoped — it only
fires while this skill is active, so it complements (without doubling)
the global `hooks/Stop.sh`.
