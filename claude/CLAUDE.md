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

## Setup on a new machine

1. Symlink the script (see command above). Confirm `which node` matches the path
   used below — this repo assumes Homebrew's `/opt/homebrew/bin/node` (Apple
   Silicon); on Intel Macs it's typically `/usr/local/bin/node`.

2. Merge these three entries into the `hooks` object in `~/.claude/settings.json`.
   If `Stop` or `SubagentStop` already have hooks configured (e.g. from another
   tool), add these as an *additional* entry in that event's `hooks` array —
   don't replace what's there.

   ```json
   {
     "hooks": {
       "SubagentStart": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "\"/opt/homebrew/bin/node\" \"/Users/tranducanh/.claude/hooks/subagent-notify.js\" start",
               "timeout": 5
             }
           ]
         }
       ],
       "SubagentStop": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "\"/opt/homebrew/bin/node\" \"/Users/tranducanh/.claude/hooks/subagent-notify.js\" stop",
               "timeout": 5
             }
           ]
         }
       ],
       "Stop": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "\"/opt/homebrew/bin/node\" \"/Users/tranducanh/.claude/hooks/subagent-notify.js\" check-stop",
               "timeout": 5
             }
           ]
         }
       ]
     }
   }
   ```

3. Validate the JSON and the new entries:

   ```bash
   python3 -c "import json; json.load(open('$HOME/.claude/settings.json'))" && echo VALID
   jq -e '.hooks.SubagentStart[0].hooks[0].command' ~/.claude/settings.json
   ```

4. Smoke-test without waiting for a real session — pipe a synthetic payload
   through each mode and confirm the counter file behaves:

   ```bash
   SID=smoke-test
   echo "{\"session_id\":\"$SID\"}" | node ~/.claude/hooks/subagent-notify.js start
   cat /tmp/claude-subagents-$SID.count   # expect 1
   echo "{\"session_id\":\"$SID\"}" | node ~/.claude/hooks/subagent-notify.js check-stop
   test -f /tmp/claude-subagents-$SID.pending && echo "suppressed correctly"
   echo "{\"session_id\":\"$SID\"}" | node ~/.claude/hooks/subagent-notify.js stop
   # should print/hear a native "Finished — waiting for input" notification now
   rm -f /tmp/claude-subagents-$SID.*
   ```

5. If the settings watcher was already running before you edited
   `settings.json`, it may not pick up new hook events until you open `/hooks`
   once (reloads config) or restart Claude Code.

## Not tracked (machine-local, stay in /tmp)

- `/tmp/claude-subagents-<session_id>.count` — live sub-agent counter.
- `/tmp/claude-subagents-<session_id>.pending` — set when a notification was
  suppressed and is waiting for the counter to reach zero.
- `/tmp/claude-subagents-<session_id>.lock` — mkdir-based mutex directory.
