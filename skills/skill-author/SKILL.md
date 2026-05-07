---
name: skill-author
description: Author a new skill following Thariq's nine rules. Use when the user wants to turn a recurring chat habit into a skill, or when an existing SKILL.md has grown beyond ~500 lines.
disable-model-invocation: true
allowed-tools: Read Write Edit Bash(mkdir *)
---

Follow the nine rules in
`${CLAUDE_SKILL_DIR}/../../references/thariq-skill-rules.md`. In summary:

1. One skill, one job. If it has "and" in the name, split it.
2. Description first — Claude picks skills by description, not by name.
3. Front-load the trigger phrases users actually say.
4. State what to do, not why.
5. Set `disable-model-invocation: true` for anything with side effects.
6. Scope `allowed-tools` to the minimum.
7. Use dynamic context (`` !`cmd` ``) instead of asking Claude to fetch.
8. Move long reference material to sibling files, link from SKILL.md.
9. Keep SKILL.md under ~500 lines (the docs' soft cap).

For *what kind of skill to write* (the 9-type taxonomy: Library/API ref,
Product Verification, Data & Analysis, Business Automation, Scaffolding,
Code Quality, CI/CD, Incident Runbooks, Infrastructure Ops) see
`${CLAUDE_SKILL_DIR}/../../references/skill-types-and-practices.md`.

Workflow:

- Ask the user: "what do you keep pasting into chat?"
- Draft `description` first, get sign-off.
- Then frontmatter, then body.
- Save to `.claude/skills/<name>/SKILL.md` (project) or
  `~/.claude/skills/<name>/SKILL.md` (personal). Confirm scope first.
