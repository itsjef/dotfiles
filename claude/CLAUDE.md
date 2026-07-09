# CLAUDE.md — Claude Code hooks

Personal Claude Code hook scripts, wired into `~/.claude/settings.json`'s `hooks` block.
Unrelated to the GSD plugin's own `gsd-*.js` hooks (those live under the GSD plugin
install, not here) — anything in this directory is hand-written, not GSD-managed.

## Files

- `hooks/subagent-notify.js` — gates the "done, waiting for input" notification so it
  doesn't fire while background sub-agents (Agent tool / Workflow fan-out) are still
  running. Tracks a live-count per `session_id` in `/tmp/claude-subagents-<session_id>.*`,
  incremented on `SubagentStart`, decremented on `SubagentStop`, guarded by a
  mkdir-based lock so concurrent parallel sub-agents don't race the counter. The
  `Stop` hook calls it in `check-stop` mode: if the counter is `0` it fires a native
  notification via `osascript` immediately; if not, it sets a pending flag that
  `stop` mode consumes once the last sub-agent finishes.

  Modes (`argv[2]`): `start` | `stop` | `check-stop` | `cleanup`.

## How it's applied

Symlinked into `~/.claude/hooks/`:

```bash
ln -s ~/dotfiles/claude/hooks/subagent-notify.js ~/.claude/hooks/subagent-notify.js
```

Wired into `~/.claude/settings.json` (not tracked here — machine-local, contains
unrelated permissions/env/plugin config) via `SubagentStart`, `SubagentStop`, and
`Stop` hook entries invoking this script with the appropriate mode.

## Not tracked (machine-local, stay in /tmp)

- `/tmp/claude-subagents-<session_id>.count` — live sub-agent counter.
- `/tmp/claude-subagents-<session_id>.pending` — set when a notification was
  suppressed and is waiting for the counter to reach zero.
- `/tmp/claude-subagents-<session_id>.lock` — mkdir-based mutex directory.
