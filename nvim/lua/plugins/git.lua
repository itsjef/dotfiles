return {
  {
    'NeogitOrg/neogit',
    dependencies = { 'sindrets/diffview.nvim' },
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        on_attach = function(_)
          local gitsigns = require('gitsigns')
          local wk = require('which-key')

          wk.add {
            -- Navigation
            {
              ']h',
              function()
                if vim.wo.diff then vim.cmd.normal({']h', bang = true})
                else gitsigns.nav_hunk('next')
                end
              end,
              desc = 'Hunk forward',
            },
            {
              '[h',
              function()
                if vim.wo.diff then vim.cmd.normal({'[h', bang = true})
                else gitsigns.nav_hunk('prev')
                end
              end,
              desc = 'Hunk backward',
            },

            -- Actions
            { '<leader>hs', gitsigns.stage_hunk, desc = 'Stage Hunk' },
            { '<leader>hr', gitsigns.reset_hunk, desc = 'Reset Hunk' },
            { '<leader>hs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = 'Stage Hunk (selection)', mode = 'v' },
            { '<leader>hr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = 'Reset Hunk (selection)', mode = 'v' },
            { '<leader>hb', function() gitsigns.blame_line({ full = true }) end, desc = 'Blame (current line)' },
            { '<leader>hS', gitsigns.stage_buffer, desc = 'Stage Buffer' },
            { '<leader>hR', gitsigns.reset_buffer, desc = 'Reset Buffer' },
            { '<leader>hp', gitsigns.preview_hunk, desc = 'Preview Hunk' },
            { '<leader>hi', gitsigns.preview_hunk_inline, desc = 'Preview Hunk (inline)' },
            { '<leader>hB', gitsigns.toggle_current_line_blame, desc = 'Blame (inline)' },

            -- Text object
            { 'ih', gitsigns.select_hunk, mode = 'ox' },
          }
        end
      }
    end
  },
}
