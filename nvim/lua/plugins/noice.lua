return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
    },
    routes = {
      {
        filter = { event = 'msg_show', kind = 'search_count' },
        skip = true,
      },
    },
    presets = {
      long_message_to_split = true,
    },
  },
  dependencies = { 'MunifTanjim/nui.nvim' }
}
