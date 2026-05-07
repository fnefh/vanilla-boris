# Skill-authoring rules (paraphrased from Thariq's guidance)

Paraphrase, not verbatim. Cited from howborisusesclaudecode.com Part 10.

1. **One skill, one job.** If the name needs an "and", split it.
2. **Description first.** Claude picks skills by description, not name.
   Front-load the actual phrases users say.
3. **Trigger phrases over generality.** "Use when the user asks what
   changed" beats "for change-related tasks".
4. **State what to do, not why.** Every line of a SKILL.md is a recurring
   token cost — see the docs' note that skill content stays in context.
5. **`disable-model-invocation: true` for side effects.** Anything that
   touches git, the filesystem, or a network is user-invoked only.
6. **Scope `allowed-tools` to the minimum.** Prefer `Bash(gh pr *)` over
   `Bash`.
7. **Use dynamic context (`` !`cmd` ``).** Don't ask Claude to fetch what
   you can inline.
8. **Move long reference material to sibling files.** SKILL.md is the
   index, not the encyclopedia.
9. **Soft cap: ~500 lines per SKILL.md.** Past that, split or move
   content out.

For *what kind of skill to write*, see `skill-types-and-practices.md`.
