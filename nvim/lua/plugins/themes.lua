return {
  {
    'akinsho/bufferline.nvim',
    version = 'v4.*',
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
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

      vim.cmd [[colo catppuccin-macchiato]]
    end,
  },
  {
    'projekt0n/github-nvim-theme',
    version = '*',
    config = function()
      require('github-theme').setup()
    end,
  },
}
