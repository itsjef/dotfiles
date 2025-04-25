require('catppuccin').setup({
  config = function()
    require('bufferline').setup({
      highlights = require('catppuccin.groups.integrations.bufferline').get(),
    })
  end
})
require('github-theme').setup()

vim.cmd [[colo catppuccin-macchiato]]
