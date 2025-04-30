local M = {}

function M.setup()
  return {
    enabled = function()
      local disabled_fts = { 'lua', 'markdown' }
      return not vim.tbl_contains(disabled_fts, vim.bo.filetype)
    end,
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      per_filetype = {
        codecompanion = { 'codecompanion' },
      },
    },
    keymap = {
      preset = 'default',
      -- on Macbook, uncheck "Switch Input Sources" shortcuts for <C-Space> to work
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_and_accept' },  -- less finger stretch
    },
    completion = {
      -- Show documentation when selecting a completion item
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = { border = 'single' },
      },

      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = true },

      menu = {
        border = 'single',
        draw = {
          components = {
            kind_icon = {
              text = function(ctx)
                local lspkind = require('lspkind')
                local icon = ctx.kind_icon
                if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                    local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                    if dev_icon then
                        icon = dev_icon
                    end
                else
                    icon = lspkind.symbolic(ctx.kind, {
                        mode = 'symbol',
                    })
                end

                return icon .. ctx.icon_gap
              end,

              -- Optionally, use the highlight groups from nvim-web-devicons
              -- You can also add the same function for `kind.highlight` if you want to
              -- keep the highlight groups in sync with the icons.
              highlight = function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                  local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            }
          }
        }
      }
    }
  }
end

return M
