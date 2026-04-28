return {
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    version = '*',
    config = function()
      local ok, cat_bl = pcall(require, 'catppuccin.special.bufferline')
      local highlights = ok and cat_bl.get_theme() or nil
      require('bufferline').setup({
        highlights = highlights,
        options = {
          show_buffer_close_icons = false,
          show_close_icon = false,
        },
      })
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        auto_integrations = true,
      })
      vim.cmd [[colo catppuccin-macchiato]]
    end,
  },
}
