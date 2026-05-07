# /sandbox

Source: howborisusesclaudecode.com §"Permissions & Safety".

`/sandbox` enables an open-source sandbox runtime for the current session.
The sandbox isolates filesystem and network access — Claude can read/write
inside it, but cannot reach files or hosts outside without an explicit
permission grant.

When to use:

- Working in an unfamiliar repo and you don't yet trust its scripts.
- Running Claude inside a CI agent or a shared machine.
- Pairing with Auto Mode — sandbox handles isolation, Auto Mode handles
  the prompts.

Pairs with: `skills/auto-mode-onboarding`, `skills/autonomy-ladder`.

## The 4-layer permission mechanism

Per the site re-audit, Claude Code's permission system is **not** just a
classifier. It's four layers stacked:

1. **Prompt-injection detection** — input from tool results / files /
   the web is screened for adversarial instructions before reaching the
   model's planning step.
2. **Static analysis** — the model's intended action is inspected
   (regex + structured analysis on Bash commands, glob patterns,
   tool-call shapes).
3. **Sandboxing** — when `/sandbox` (or `sandbox.enabled`) is on, the
   action runs inside the isolated runtime no matter what.
4. **Oversight** — for actions classified as risky, the user (or a
   PermissionRequest hook routed to Slack/WhatsApp/Opus) approves
   per-call.

Auto Mode is a *fast-path* on layer 4 — obviously-safe actions skip the
prompt. The other three layers are not weakened.

This plugin documents `/sandbox`; it does not auto-enable it. See
`hooks/PermissionRequest.sh` for an opt-in example of routing layer-4
prompts.
