#!/usr/bin/env bun
// Nine-step interactive setup. Prints what it will do; never writes
// without confirmation; never asks for credentials.
import { $ } from "bun";

const ask = async (q: string): Promise<string> => {
  process.stdout.write(`${q} `);
  for await (const line of console) return line.trim();
  return "";
};
const yes = async (q: string) => /^y/i.test(await ask(`${q} [y/N]`));

console.log("vanilla-boris wizard — nine steps, all skippable.\n");

// Step 1 — north-star CLAUDE.md
if (await yes("1) Generate or refresh CLAUDE.md via the north-star skill?")) {
  console.log("   Open Claude Code in this repo and run:  /north-star");
}

// Step 2 — plan-first nudge hook
if (await yes("2) Enable the plan-first prompt nudge (UserPromptSubmit hook)?")) {
  console.log("   Already installed by install.sh. No-op.");
}

// Step 3 — autocompact threshold (verbatim line)
console.log("\n3) Auto-compact threshold");
console.log("   Recommended:  CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000 claude");
if (await yes("   Print this as a copy-paste hint each session?")) {
  console.log("   (No file changes — wizard just printed it.)");
}

// Step 4 — MCP audit
if (await yes("4) Run the MCP audit checklist now?")) {
  try { console.log(await $`claude mcp list`.text()); }
  catch { console.log("   `claude mcp list` not available — open Claude Code and run /mcp-audit."); }
}

// Step 5 — loop recipes
console.log("\n5) /loop recipes (Anthropic-bundled /loop, our reconstructed targets):");
console.log("     /loop 5m /babysit");
console.log("     /loop 30m /slack-feedback");
console.log("     /loop /post-merge-sweeper");
console.log("     /loop 1h /pr-pruner");
console.log("   Read references/loop-recipes.md before scheduling any of these.");

// Step 6 — verification path  (NEW in v3)
console.log("\n6) Verification path (Boris's #1 principle)");
const verify = await ask("   What command verifies a change works? (e.g. 'bun test', 'make verify', 'open localhost:3000', 'none')");
if (verify && verify !== "none") {
  console.log(`   Add this to CLAUDE.md under "How to verify a change works": ${verify}`);
  console.log("   The /verify skill will pick it up automatically.");
} else {
  console.log("   Skipped. Without a verify command, /verify will ask you each time.");
}

// Step 7 — Auto Mode  (NEW in v3)
console.log("\n7) Auto Mode");
console.log("   Auto Mode auto-approves obviously-safe operations using a classifier.");
console.log("   Risky operations still prompt. Pair with /fewer-permission-prompts.");
console.log("   We do NOT flip it for you. To enable: relaunch with --enable-auto-mode");
console.log("   or toggle mid-session with shift+tab.");
console.log("   Background reading: skills/auto-mode-onboarding/SKILL.md.");

// Step 8 — @claude GitHub bot  (NEW in v3)
console.log("\n8) @claude GitHub bot");
console.log("   The @claude bot listens for mentions in PR comments and updates");
console.log("   CLAUDE.md, runs reviews, etc. (see references/github-bot.md).");
if (await yes("   Run /install-github-action now? (Opens a browser for OAuth.)")) {
  console.log("   Open Claude Code and run:  /install-github-action");
} else {
  console.log("   Skipped. You can run /install-github-action anytime.");
}

// Step 9 — Routines  (NEW in v3)
console.log("\n9) Routines (cloud /schedule)");
console.log("   Sample recipes — see references/routine-recipes.md:");
console.log("     - Auto-resolve CI failures (trigger: GitHub check_run failed)");
console.log("     - Weekly CLAUDE.md review (trigger: cron Fri 16:00)");
console.log("     - Daily PR triage (trigger: cron 09:00)");
console.log("     - Deploy-on-merge canary (trigger: PR merged)");
console.log("   We do NOT schedule any. Configure connectors via Claude Code's");
console.log("   settings UI when you're ready.");

// Step 10 — status line + spinner verbs  (NEW in v0.3.0)
console.log("\n10) Status line & spinner verbs (shipped via plugin.json settings)");
console.log("    Status line:  vanilla-boris ▸ {model} ▸ {context_pct}% ▸ {git_branch} ▸ {cost}");
console.log("    Spinner verbs: verifying, checking, auditing, inspecting, ...");
console.log("    Both are subagent-scoped, so they only apply when our agents spawn.");
if (await yes("    Print the snippet for setting them session-wide via settings.json?")) {
  console.log(`    Add to ~/.claude/settings.json:
      "statusLine": "vanilla-boris ▸ {model} ▸ {context_pct}% ▸ {git_branch}",
      "spinnerVerbs": ["verifying", "checking", "auditing", "inspecting",
                       "tracing", "validating", "scrutinizing", "weighing",
                       "probing", "testing", "rehearsing", "double-checking"]`);
}

// Step 11 — worktree shell aliases  (NEW in v0.3.0)
console.log("\n11) Worktree shell aliases (Boris's za/zb/zc trick)");
console.log("    See references/shell-aliases.md for the full snippet.");
if (await yes("    Print the zsh aliases now?")) {
  console.log(`    alias za='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/a" && claude --worktree a'
    alias zb='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/b" && claude --worktree b'
    alias zc='cd "$(git rev-parse --show-toplevel)/.claude/worktrees/c" && claude --worktree c'`);
}

// Step 12 — env-vars summary  (NEW in v0.3.0)
console.log("\n12) Env vars cheatsheet");
console.log("    Boris's site mentions 84 env vars; the docs list 102+. The");
console.log("    high-value subset is documented in references/env-vars.md");
console.log("    (compaction, effort, hooks, worktrees, plugin-defined).");

console.log("\nDone.");
