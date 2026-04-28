# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository overview

Personal dotfiles for macOS, organized by tool. Each subdirectory has its own `CLAUDE.md` with tool-specific detail:

- `nvim/` — Neovim config (Lua, lazy.nvim). See `nvim/CLAUDE.md`.
- `tmux/` — tmux config (`tmux.conf` + bundled plugins). See `tmux/CLAUDE.md`.
- `ghostty/` — Ghostty terminal config. See `ghostty/CLAUDE.md`.
- `wezterm/` — WezTerm config (`wezterm.lua`, Lua).
- `kitty/` — Kitty terminal config (`kitty.conf`).
- `.zshrc` / `.zsh_env_vars` — Zsh shell config (oh-my-zsh + Powerlevel10k).
- `.tmux.conf` — Legacy root-level tmux config (old/minimal; the active config is `tmux/tmux.conf`).

## How configs are applied

There is no install script. Configs are applied by symlinking (or copying) each file/directory to its expected location:

| Source | Target |
|--------|--------|
| `nvim/` | `~/.config/nvim/` |
| `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` |
| `ghostty/config.ghostty` | `~/.config/ghostty/config` |
| `wezterm/wezterm.lua` | `~/.config/wezterm/wezterm.lua` |
| `.zshrc` | `~/.zshrc` |
| `.zsh_env_vars` | `~/.zsh_env_vars` (gitignored — contains secrets/machine-local vars) |

## Cross-config dependencies

Several settings must stay in sync across tools:

- **smart-splits.nvim navigation**: Move panes with Alt-hjkl (Meta-hjkl in WezTerm), resize with Ctrl-hjkl. This mapping is declared in `wezterm/wezterm.lua` (via `smart_splits.apply_to_config`), in `tmux/tmux.conf`, and in the Neovim smart-splits plugin config. Changes to direction keys or modifiers must be mirrored in all three.
- **Shift+Enter → literal newline**: Both `wezterm/wezterm.lua` and `ghostty/config.ghostty` bind Shift+Enter to `\x1b\r` so Claude Code's input box accepts literal newlines. If you change one, update the other.
- **Tmux prefix**: `C-s` in both `tmux/tmux.conf` and `wezterm/wezterm.lua` (`config.leader`).
- **Catppuccin flavor**: tmux and Ghostty use Macchiato; WezTerm uses Mocha (Gogh). These are intentionally different shades — don't unify without checking contrast.

## Zsh config (`.zshrc`)

- **Theme**: Powerlevel10k; prompt config lives in `~/.p10k.zsh` (not tracked here).
- **Plugins**: `git aws kubectl poetry poetry-env z zsh-autosuggestions zsh-syntax-highlighting` (oh-my-zsh).
- **Python**: pyenv + pyenv-virtualenv. `PYENV_ROOT` is set; `pyenv init` and `pyenv virtualenv-init` run at shell start.
- **Aliases**: `vim`/`v` → Homebrew nvim. `dj*` aliases for Django management commands (`dj`, `djs`, `djss`, `djm`, `djmm`, `djr`).
- **Path additions**: `~/.local/bin`, pyenv, Scala 2.12, PostgreSQL 15 (Homebrew cellar paths).
- **Secrets**: `~/.zsh_env_vars` is sourced at the end if present; that file is gitignored.

## WezTerm config (`wezterm/wezterm.lua`)

Lua config using `wezterm.config_builder()`. Notable settings:
- Font: IosevkaTerm Nerd Font Mono Medium, ligatures disabled (`calt=0 clig=0 liga=0`).
- Color scheme: Catppuccin Mocha (Gogh).
- Leader: `C-s`. Splits: `LEADER+\` horizontal, `LEADER+-` vertical (25% height).
- Mouse: left-click selects (not open link); Ctrl+click opens hyperlink.
- smart-splits integration loaded via `wezterm.plugin.require` — move modifier is `META`, resize modifier is `CTRL`.

Requires the `wezterm` TERM definition installed in `~/.terminfo` (see README.md for the install command).

## Gitignored items

- `.zsh_env_vars` — machine-local env vars and secrets.
- `nvim/lazy-lock.json` — plugin lockfile (gitignored at repo root despite nvim/CLAUDE.md suggesting otherwise).
- `nvim/temp_dir/*` — persistent undo history.
- `tmux/plugins/*` — local plugin checkouts (not authoritative; `tmux.conf` references drive loading).
