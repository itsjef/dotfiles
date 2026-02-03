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
        auto_integrations = true,
        config = function()
          require('bufferline').setup({
            highlights = require('catppuccin.special.bufferline').get_theme(),
            options = {
              show_buffer_close_icons = false,
              show_close_icon = false,
            },
          })
        end,
      })

      vim.cmd [[colo catppuccin-macchiato]]
    end,
  },
}
