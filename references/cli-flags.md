# Useful Claude CLI flags

Source: howborisusesclaudecode.com (CLI examples) + code.claude.com/docs.

These are bundled CLI flags the site cites by name. We document them
here so they're discoverable without having to grep the official docs.

## Worktrees & sessions

```
claude --worktree <name>          # run in an isolated git worktree
claude --worktree <name> --tmux   # ... inside a tmux session
claude -w <name>                  # shorthand for --worktree
claude --name "auth-refactor"     # human-readable session name
claude --resume <session-id>      # resume a past session
claude --resume <id> --fork-session   # resume but start a new branch
```

## Performance

```
claude --bare                     # skip settings/MCPs (10× faster start)
                                  # use when settings load is the bottleneck
```

## Permissions & autonomy

```
claude --enable-auto-mode         # start with Auto Mode on
claude --permission-mode=dontAsk  # sandboxed environments only
                                  # NEVER use on a host machine
claude --dangerously-skip-permissions
                                  # not recommended; this plugin avoids it
```

## Multi-directory

```
claude --add-dir /path/to/other-repo
                                  # give Claude access to additional folders
                                  # also: /add-dir at runtime, or
                                  # additionalDirectories in settings.json
```

## Agents & SDK

```
claude --agent=<agent-name>       # launch a specific agent up front
claude -p "prompt"                # non-interactive single-shot
claude --output-format=stream-json
                                  # SDK output format for piping
claude --print "/skills"          # used by our tests/skills-load.test.sh
```

## Notes

- **`--bare` and `--print` are great for tests / CI** — they skip the
  costly settings load and produce machine-readable output.
- **`--dangerously-skip-permissions`** is intentionally absent from this
  plugin's tooling. Per `skills/autonomy-ladder` and `skills/auto-mode-onboarding`,
  Auto Mode + sandbox is the safer way to reduce prompts.
- **`-w` shorthand** is a small comfort — Boris uses both forms on his
  site.
