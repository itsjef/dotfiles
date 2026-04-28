-- Byte-code cache (must be first)
vim.loader.enable()

-- Map leader key
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Disable unused providers (they cost startup time scanning for interpreters)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- Disable unused built-in plugins
vim.g.loaded_netrw = 1            -- replaced by oil.nvim
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tutor = 1
vim.g.loaded_matchit = 1          -- replaced by vim-matchup
vim.g.loaded_2html_plugin = 1
vim.g.loaded_rplugin = 1
vim.g.loaded_spellfile_plugin = 1

-- enable ui2
require('vim._core.ui2').enable({})

-- plugins with lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
require('lazy').setup({
  spec = { { import = 'plugins' } },
  change_detection = { enabled = false },
})

-- Load other configs
require('general')

-- Defer keymappings setup until which-key (VeryLazy) has loaded.
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  once = true,
  callback = function() require('keymappings').setup({}) end,
})
