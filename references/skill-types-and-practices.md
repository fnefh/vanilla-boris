# Skill types and best practices

Source: howborisusesclaudecode.com §"Skill Development & Distribution".
Verbatim taxonomy; paraphrased best practices.

## The 9 skill types

1. **Library & API reference** — function signatures, gotchas, version
   pins. Useful when Claude's training data lags the current SDK.
2. **Product verification** — drives a running product (browser, CLI,
   API) to prove a change works end-to-end.
3. **Data & analysis** — schemas, field names, query patterns,
   warehouses.
4. **Business automation** — multi-tool workflows (Slack → Linear → PR).
5. **Scaffolding & templates** — framework boilerplate, new-feature
   wizards.
6. **Code quality & review** — adversarial review, style enforcement,
   duplication detection.
7. **CI/CD & deployment** — commit, push, deploy *safely* (sequenced
   gates, rollbacks).
8. **Incident runbooks** — symptom → investigation → fix.
9. **Infrastructure ops** — safety-gated cleanup of cloud resources.

## Best practices

- **Skip the obvious.** Claude has defaults; don't restate them.
- **Build a "Gotchas" section.** Highest-signal-per-line content.
- **Progressive disclosure.** Top-level SKILL.md is the index; deeper
  detail lives in sibling files (the docs' folder structure pattern).
- **Don't railroad.** Give Claude information, not a script. Scripts go
  stale; information adapts.
- **Description = trigger.** Write the description for the model's skill
  picker, not for humans browsing the file.
- **Think through setup.** Use `config.json` for skill configuration and
  `${CLAUDE_PLUGIN_DATA}` for persistent state.
- **Give helper code.** When a sub-task is mechanical, ship the helper
  (small Python/TS module) rather than asking Claude to reconstruct it
  each time.
- **On-demand hooks.** Skills can register session-scoped hooks for
  guardrails that only apply while the skill is active.
