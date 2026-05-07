---
name: learn-codebase
description: Generate an HTML presentation that explains an unfamiliar codebase, protocol, or system. Reconstruction of Boris's pattern from his Mar 30 2026 hidden-features thread ("have Claude generate visual HTML presentations explaining unfamiliar code"). Use when onboarding to a new repo, before reviewing a large PR, or when the user says "explain this codebase".
disable-model-invocation: true
allowed-tools: Read Grep Glob Write Bash(git ls-files *) Bash(git log *) Bash(open *)
context: fork
agent: code-architect
---

> **Reconstruction notice.** Boris references this pattern verbatim on
> the Mar 30 2026 thread (transcribed in the
> shanraisshan/claude-code-best-practice repo) but does not publish a
> skill. This is our reconstruction.

## Repo snapshot
- Tracked files: !`git ls-files | wc -l`
- Top-level entries: !`ls -1 | head -20`
- Last 10 commits: !`git log --oneline -10 2>/dev/null || echo "(not a git repo)"`
- Existing CLAUDE.md: !`test -f CLAUDE.md && head -40 CLAUDE.md || echo "(none)"`

## Instructions

Produce a single-file HTML presentation (`.claude/learn-<topic>.html`)
that explains this codebase to a developer who has never seen it.
Slide structure:

1. **What this repo is** — one sentence + what category (web, CLI, lib,
   infra).
2. **Tech stack** — languages, frameworks, build/test tools, runtime
   targets.
3. **Architecture diagram** — ASCII art or simple SVG. Boxes for the 3–5
   load-bearing modules, arrows for data flow.
4. **Key abstractions** — 3–5 named types/interfaces and what they do.
   File:line citations.
5. **Lifecycle of a typical request/build** — step-by-step trace through
   the system for the most common operation.
6. **Where the test surface lives** — paths and how to run them.
7. **Gotchas** — 3–5 non-obvious facts a new contributor would
   otherwise get wrong.
8. **Glossary** — domain-specific terms used in this repo, defined.
9. **Where to start** — the 3 best files to read first.

## Output

- Write to `.claude/learn-<topic>.html` (`<topic>` defaults to the repo
  basename).
- Use plain HTML + minimal inline CSS. No external dependencies, no
  JS frameworks.
- Include a print stylesheet so it works in single-page mode.
- After writing, print the file path and offer to open it
  (`open .claude/learn-<topic>.html` on macOS).

## Why HTML, not Markdown

Boris specifically calls out *visual* presentations. ASCII diagrams in
Markdown work but HTML is more legible (real boxes, real arrows,
syntax-highlighted code blocks, collapsible sections). Static HTML
(no JS) keeps the artifact portable.

## Composition

This skill runs in a forked subagent (`context: fork`) so the deep
codebase exploration doesn't pollute the main thread. The
`code-architect` agent (if shipped — currently in the
boris-named-skills attribution list, not implemented) can host the
fork; otherwise the skill runs in the default fork.
