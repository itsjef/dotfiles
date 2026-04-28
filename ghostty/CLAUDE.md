# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Scope

Single-file Ghostty terminal config (`config.ghostty`). Declarative `key = value` pairs, one option per line; repeated keys (e.g. `font-feature`, `keybind`) accumulate.

## Conventions

- Targets macOS (`fullscreen`, `macos-option-as-alt`, `quit-after-last-window-closed` are macOS-only).
- Ligatures are intentionally disabled via three `font-feature = -calt/-clig/-liga` lines — preserve all three when touching font config.
- `keybind = shift+enter=text:\x1b\r` exists so Claude Code's input box accepts a literal newline (mirrors the WezTerm config). Do not remove without checking the WezTerm side stays in sync.
- Theme is Catppuccin Macchiato to match the tmux config (`tmux/tmux.conf` sets `@catppuccin_flavor 'macchiato'`).

## Reloading

Ghostty has no `reload-config` CLI; changes apply on app relaunch (or via the in-app "Reload Configuration" command). There is no build/test step in this directory.
