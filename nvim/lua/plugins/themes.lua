return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
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
            options = {
              show_buffer_close_icons = false,
              show_close_icon = false,
            },
          })
        end,
        integrations = {
          colorful_winsep = { enabled = true },
          diffview = true,
          render_markdown = true,
          mason = true,
          mini = { enabled = true, indentscope_color = '' },
          noice = true,
          snacks = { enabled = true },
        }
      })

      vim.cmd [[colo catppuccin-macchiato]]
    end,
  },
}
