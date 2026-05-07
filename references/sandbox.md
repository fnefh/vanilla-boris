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

This plugin documents `/sandbox`; it does not auto-enable it.
