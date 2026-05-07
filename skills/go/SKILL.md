---
name: go
description: "Just do the obvious next thing." Reconstruction of the /go shortcut Boris referenced on his site. Use when the user has reviewed a plan and wants execution to proceed without further confirmation on each step.
disable-model-invocation: true
---

> **Reconstruction notice.** Boris referenced `/go` on
> howborisusesclaudecode.com but did not publish its contents. This is our
> faithful reconstruction based on the surrounding context (it's the
> "execute the plan we just agreed on" companion to plan-mode).

Execute the most recently agreed-upon plan. Concretely:

1. Re-state the plan in one sentence so the user can interrupt if you've
   drifted.
2. Work through the plan's file list in order.
3. After each file, run the narrowest applicable check (type-check for a
   `.ts` edit, the file's own test for a `.test.ts`, etc.) — see the
   `three-loop` skill.
4. When the plan's last step is done, **run the verify command** before
   declaring success — see `skills/verify`. Do not skip this.
5. Stop and report when the plan is done **or** when reality diverges from
   the plan (a file you expected to exist doesn't, a test fails in a way
   the plan didn't anticipate). Do not improvise past the plan's edge.

`/go` is not a license to escalate autonomy. Tools you'd normally ask
about (destructive Bash, network, package installs) still require
approval. See the `autonomy-ladder` skill.
