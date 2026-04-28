# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Scope

Single-file tmux config (`tmux.conf`) plus a `plugins/` directory tracking the plugin set this config expects. The directory does **not** auto-install anything; plugins must be present at the paths below before the config will work.

## Plugin loading — non-standard

- Plugin manager is **tpm-redux** loaded from `~/.tmux/plugins/tpm-redux/tpm` (the last line of `tmux.conf`). This is **not** the upstream `tmux-plugins/tpm` path; do not "fix" it.
- Catppuccin is **not** managed by tpm — it is loaded directly via `run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux`. The clone command is in a comment above that line:
  ```
  git clone -b v2.3.0 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
  ```
  Keep that comment in sync if the version is bumped.
- The `plugins/` directory in this repo (`smart-splits.nvim`, `tmux-resurrect`, `tmux-sensible`, `catppuccin`) is a local snapshot/checkout, not authoritative — `tmux.conf` references are what actually drive loading.

## Key conventions

- Prefix is `C-s` (rebound from default `C-b`); `bind C-s send-prefix` lets nested sessions still receive it.
- Splits open in `#{pane_current_path}` (`\` horizontal, `-` vertical) — preserve the `-c` flag when editing.
- Navigation/resize keys come from **smart-splits.nvim** (Alt-hjkl move, Ctrl-hjkl resize). These bindings are seamless with Neovim splits, so changes here must be mirrored in the Neovim smart-splits config in `nvim/`.
- Terminal overrides assume Ghostty (`set -ag terminal-features "ghostty:RGB"`) — this dotfiles repo's primary terminal is Ghostty (see `ghostty/CLAUDE.md`).
- Catppuccin window-text format uses a nested `#{s|...|...|}` substitution to abbreviate `$HOME` to `~` and shorten parent path components to one letter; both `@catppuccin_window_text` and `@catppuccin_window_current_text` must stay identical.

## Reloading

No build/test. Apply changes with `tmux source-file ~/.config/tmux/tmux.conf` (or `prefix : source-file ...`). New plugins added to the `set -g @plugin` list need `prefix + I` (tpm-redux install) after sourcing.
