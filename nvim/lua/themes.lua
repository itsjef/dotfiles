require('catppuccin').setup({
  config = function()
    require('bufferline').setup({
      highlights = require('catppuccin.special.bufferline').get_theme(),
    })
  end,
  integrations = {
    colorful_winsep = { enabled = true },
    diffview = true,
    hop = true,
    render_markdown = true,
    mason = true,
    noice = true,
    snacks = { enabled = true },
  }
})
require('github-theme').setup()

vim.cmd [[colo catppuccin-macchiato]]
