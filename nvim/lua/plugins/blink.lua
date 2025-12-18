return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },
  -- use a release tag to download pre-built binaries
  version = '1.*',
  opts_extend = { 'sources.default' },
  config = function()
    require('blink.cmp').setup {
      -- enabled = function()
      --   local disabled_fts = { 'lua', 'markdown' }
      --   return not vim.tbl_contains(disabled_fts, vim.bo.filetype)
      -- end,
      signature = {
        enabled = true,
        window = { border = 'single' }
      },
      cmdline = {
        enabled = true,
        completion = {
          list = { selection = { preselect = false, auto_insert = true } },
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lsp = {
            min_keyword_length = 2,
            score_offset = 0,
          },
          path = {
            min_keyword_length = 0,
          },
          snippets = {
            min_keyword_length = 2,
          },
          buffer = {
            min_keyword_length = 5,
            max_items = 5,
          },
        },
        per_filetype = {},
      },
      keymap = {
        preset = 'enter',
        ['<Tab>'] = {
          function(cmp)
            return cmp.select_next()
          end,
          'snippet_forward',
          'fallback',
        },
        ['<S-Tab>'] = {
          function(cmp)
            return cmp.select_prev()
          end,
          'snippet_backward',
          'fallback',
        },
        ['<C-j>'] = { 'select_and_accept' }, -- less finger stretch
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
        documentation = { auto_show = true, window = { border = 'single' } },
        trigger = { prefetch_on_insert = false }, -- Avoid unnecessary request
        menu = {
          auto_show = true,
          border = 'single',
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                  return kind_icon
                end,
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
              kind = {
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
            },
            columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon' }, { 'kind' } },
            treesitter = { 'lsp' },
          },
        },
      },
    }
  end,
}
