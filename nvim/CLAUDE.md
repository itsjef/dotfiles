# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository

Personal Neovim configuration. The directory is symlinked (or sourced) as `~/.config/nvim`. There is no build/test/lint pipeline — changes are validated by reloading Neovim.

## Common operations

- **Apply changes**: restart Neovim, or `:source %` for a single file. `vim.loader.enable()` byte-code caches modules, so after editing a `.lua` file under `lua/` you generally want a fresh Neovim process.
- **Plugin management** (`lazy.nvim`): `:Lazy sync`, `:Lazy update`, `:Lazy clean`, `:Lazy profile`. Lockfile is `lazy-lock.json` — commit it after intentional updates.
- **LSP / tools** (`mason.nvim`): `:Mason`, `:MasonInstall <name>`, `:MasonUpdate`. Servers auto-installed are listed in `lua/plugins/z-lsp.lua` (`ensure_installed`).
- **Treesitter**: `:checkhealth nvim-treesitter`. Parsers are installed deferred via the list in `lua/plugins/treesitter.lua`.
- **Diagnose startup**: `:Lazy profile` for plugin load times, `:checkhealth` for general issues.

## Architecture

Entry point is `init.lua`. Load order matters and is roughly:

1. `vim.loader.enable()` — must be first.
2. Leader key set to `,` (both `mapleader` and `maplocalleader`) **before** lazy.nvim loads, since plugin specs reference `<leader>`.
3. Disable unused providers (perl/ruby/node/python3) and built-in plugins (netrw, matchit, etc.) — these are intentional startup-time optimizations.
4. Enable experimental `vim._core.ui2` with `cmdheight = 0`.
5. `lazy.nvim` bootstraps and imports everything under `lua/plugins/` (see `init.lua:48-51`).
6. `require('general')` — global options, persistent undo dir (`temp_dir/undo`), relative-number toggle by mode, treesitter highlighting/indent autocmds for a curated filetype list.
7. **Keymaps are deferred** until the `User VeryLazy` autocmd fires, so `which-key` is loaded before `keymappings.setup()` runs (`init.lua:57-61`). Don't move keymap registration earlier — it depends on which-key.

### Plugin layout (`lua/plugins/`)

Each file returns a lazy.nvim spec list, grouped by concern: `editor.lua` (UI/file/git/AI), `telescope.lua`, `themes.lua`, `lualine.lua`, `blink.lua` (completion), `mini.lua` (mini.nvim modules), `treesitter.lua`, `z-lsp.lua` (LSP — `z-` prefix forces it to load last alphabetically when `lazy.nvim` imports the directory).

Plugins are aggressively lazy-loaded via `event`, `cmd`, `ft`, or `keys`. When adding a plugin, prefer one of those triggers over `lazy = false`. Two plugins are intentionally eager:
- `mini.nvim` (`priority = 900`) — only `mini.icons` is set up eagerly because lualine/blink/oil read icons at startup; the rest of mini's modules are deferred to `VeryLazy` (see `lua/plugins/mini.lua`).
- `nvim-treesitter` — eager but parser install is deferred to `VeryLazy`.

### Keymaps (`lua/keymappings.lua`)

All keymaps are registered through `which-key.add`. Three entry points on module `M`:
- `M:setup()` — global maps; called from `init.lua` on `VeryLazy`.
- `M:lsp_keys(bufnr)` — buffer-local LSP maps; called from the `LspAttach` autocmd in `lua/plugins/z-lsp.lua` (and from nvim-metals `on_attach`).
- `M:gitsigns_keys(bufnr)` — buffer-local gitsigns maps; called from gitsigns `on_attach` in `lua/plugins/editor.lua`.

The `lazy(mod, fn)` helper at the top of the file returns a thunk that `require`s the plugin only when the key is pressed. **Use `lazy()` (or `function() require(...).fn() end`) for plugin keymaps** — referencing `require('plugin').fn` directly at module load defeats lazy.nvim's `event/cmd/keys` triggers.

LSP default keybindings (`grn`, `gra`, `gri`, `grr`, `grt`) are explicitly deleted before custom ones are attached (`lua/plugins/z-lsp.lua:17-19`). Likewise `K` is removed per-buffer in LSP `on_attach` so the custom `lsp.buf.hover` map wins.

Leader-prefix groups: `<leader>a` AI/Claude, `<leader>f` Telescope, `<leader>g` Neogit, `<leader>h` gitsigns + markdown, `<leader>m` markdown.

### LSP

Capabilities are wired through `blink.cmp.get_lsp_capabilities()` and applied via `vim.lsp.config('*', ...)`. Pyright is configured to ignore everything (`analysis.ignore = { '*' }`) — `ruff` handles diagnostics. Scala/Java uses `nvim-metals` (not lspconfig) and is wired separately with its own `on_attach`.

### Filetype-driven loading

`lua/general.lua` starts treesitter highlighting on a fixed filetype allowlist; treesitter indent (`indentexpr`) is only enabled for `html, lua, markdown, python, toml, typst, yaml`. Adding a new language usually means: add to the parser install list (`lua/plugins/treesitter.lua`), add to the FileType autocmd allowlist (`lua/general.lua`), and if relevant add an LSP server to `ensure_installed` (`lua/plugins/z-lsp.lua`).

### Notes & gotchas

- `<C-h>` is bound twice intentionally: normal mode = `smart-splits.resize_left`, insert mode = `lsp.buf.signature_help`.
- Some plugin keymap conflicts are resolved at attach time (e.g. `markdown-plus` `]b`/`[b` is rebound to `]\``/`[\`` because `mini.bracketed` owns `]b`/`[b`).
- `change_detection = { enabled = false }` in lazy setup — config edits don't auto-reload.
- `.luarc.json` declares the `vim`/`Mini*`/`Snacks` globals for lua-language-server. Add new globals here when introducing plugins that expose one.
- Custom git provider mapping for `git.parcelperform.com` is configured in `gitportal.nvim` (see `lua/plugins/editor.lua`).
