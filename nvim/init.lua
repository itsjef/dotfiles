-- Map leader key
vim.g.mapleader = ','

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
  spec = {
    { import = 'lazy_plugins' },
  },
  change_detection = {
    enabled = false,
  }
})

-- Load plugin configs
require('pluginconfigs')
require('lspconfigs')

-- Load other configs
require('general')
require('themes')
require('keymappings').setup({})
