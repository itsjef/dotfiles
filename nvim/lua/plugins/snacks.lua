return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  config = function()
    require('snacks').setup {
      bigfile = { enabled = true },
      gitbrowse = {
        url_patterns = {
          ['git%.parcelperform%.com'] = {
            branch = '/-/tree/{branch}',
            file = '/-/blob/{branch}/{file}#L{line_start}-L{line_end}',
            permalink = '/-/blob/{commit}/{file}#L{line_start}-L{line_end}',
            commit = '/-/commit/{commit}',
          },
        }
      },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = {
        layout = 'sidebar',
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            },
          },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    }
  end,
}
