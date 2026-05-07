---
name: north-star
description: Write or refresh the project's CLAUDE.md as a short, factual north-star — the kind of file that survives auto-compaction and tells future-you (and Claude) the few non-obvious facts about this repo. Use when starting a new repo, when CLAUDE.md drifts past ~80 lines, or when the user says "update CLAUDE.md".
disable-model-invocation: true
allowed-tools: Read Edit Write Bash(git ls-files *)
---

## Repo snapshot
- Tracked files: !`git ls-files | wc -l`
- Top-level entries: !`ls -1`
- Existing CLAUDE.md (if any): !`test -f CLAUDE.md && cat CLAUDE.md || echo "(none)"`

## Instructions

Produce a CLAUDE.md that obeys the north-star rule from
howborisusesclaudecode.com Part 1: **short, factual, durable**.

Sections, in order, each one paragraph or fewer:

1. **What this repo is** — one sentence.
2. **How to run / test / lint** — exact shell commands. Cite verbatim from
   `package.json`, `Makefile`, or equivalent. Do not invent commands.
3. **Conventions that aren't obvious** — only the ones a new contributor
   would otherwise get wrong (e.g. "we use `bun`, not `npm`"; "all PRs
   squash-merge"; "tests live next to source as `*.test.ts`").
4. **Where the load-bearing code is** — 3–6 paths, no more.
5. **How to verify a change works** — the verify command (`bun test`,
   `bun typecheck`, browser URL, etc.). Pairs with `skills/verify`.
6. **What this file is not** — one line: "Not a tutorial. Not a changelog.
   Not a tour."

Hard caps:
- ≤ 80 lines total.
- No emoji, no marketing language, no "this project aims to…".
- Every command must be runnable as written.

If the existing CLAUDE.md already satisfies these rules, say so and exit
without editing. If you propose changes, show a diff first and ask before
writing.

For the canonical example of what a tight CLAUDE.md looks like, see
`${CLAUDE_SKILL_DIR}/../../references/boris-claude-md.txt` (verbatim
excerpt from @bcherny's Jan 2 2026 thread, used here for reference only).
