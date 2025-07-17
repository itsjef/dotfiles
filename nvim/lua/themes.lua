require('catppuccin').setup({
  config = function()
    require('bufferline').setup({
      highlights = require('catppuccin.groups.integrations.bufferline').get(),
    })
  end,
  integrations = {
    colorful_winsep = { enabled = true },
    diffview = true,
    hop = true,
    markview = true,
    mason = true,
    noice = true,
    snacks = { enabled = true },
  }
})
require('github-theme').setup()

vim.cmd [[colo catppuccin-macchiato]]
