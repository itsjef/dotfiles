# CLAUDE.md — RTK config

RTK (Rust Token Killer) is a token-optimizing CLI proxy wired into Claude Code as a
`PreToolUse` hook (`rtk hook claude`, configured in `~/.claude/settings.json`). It rewrites
dev commands like `git status` → `rtk git status` to compact their output.

## Files

- `config.toml` — main config: tracking, display, output filters, tee, telemetry, and the
  `[hooks]` section. `exclude_commands` lists command prefixes (token-prefix match) that
  RTK passes through **raw** (no rewrite). Current entries: `git diff`, `git log`,
  `git show`, `grep` — excluded because RTK's compaction truncated git history/diffs and
  actively mangled grep line content, forcing `Read` fallbacks (evidenced across many past
  sessions). Full, uncorrupted output for these now reaches Claude.
- `filters.toml` — user-global output-compaction filters applied across all projects.
  A project-local `.rtk/filters.toml` takes precedence.

## How it's applied

macOS RTK reads config from `~/Library/Application Support/rtk/`, and there is no
config-path override flag, so both files are **symlinked** from this repo into that dir:

```bash
ln -s ~/dotfiles/rtk/config.toml  "$HOME/Library/Application Support/rtk/config.toml"
ln -s ~/dotfiles/rtk/filters.toml "$HOME/Library/Application Support/rtk/filters.toml"
```

Verify RTK reads it: `rtk config` prints the resolved path, and
`rtk hook check 'git diff'` should report `No rewrite for: git diff`.

## Not tracked (machine-local, stay in Application Support)

- `history.db` — command-usage database (backs `rtk gain` / `rtk discover`), multi-MB.
- `.hook_warn_last` — hook warning state.
- `tee/` — captured command output.
