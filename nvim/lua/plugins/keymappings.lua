return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
    opts = {
      preset = 'helix',
      delay = function(ctx)
        return ctx.plugin and 0 or 500
      end,
    },
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)

      local smart_splits = require('smart-splits')
      local flash = require('flash')
      local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')

      wk.add {
        -- groups
        { '<leader>g', group = 'Neogit' },
        { '<leader>h', group = 'Markdown and Gitsigns' },
        { '<leader>m', group = 'Markdown (the rest)' },
        { '<leader>s', group = 'Snacks Pickers' },

        -- hidden key mappings
        {
          hidden = true,
          -- Quick shortcut for splittling
          { '<C-W>-', ':split<CR>' },
          { '<C-W>\\', ':vsplit<CR>' },

          -- Break undo sequence to smaller chunks
          { '.', '.<C-g>u', mode = 'i' },
          { '?', '?<C-g>u', mode = 'i' },
          { '!', '!<C-g>u', mode = 'i' },
          { ',', ',<C-g>u', mode = 'i' },

          -- smart-splits
          -- resizing splits
          -- these keymaps will also accept a range,
          -- for example `10<C-h>` will `resize_left` by `(10 * config.default_amount)`
          { '<C-h>', smart_splits.resize_left },
          { '<C-j>', smart_splits.resize_down },
          { '<C-k>', smart_splits.resize_up },
          { '<C-l>', smart_splits.resize_right },
          -- moving between splits
          { '<A-h>', smart_splits.move_cursor_left },
          { '<A-j>', smart_splits.move_cursor_down },
          { '<A-k>', smart_splits.move_cursor_up },
          { '<A-l>', smart_splits.move_cursor_right },
          { '<A-\\>', smart_splits.move_cursor_previous },
          -- swapping buffers between windows
          { '<leader><leader>h', smart_splits.swap_buf_left },
          { '<leader><leader>j', smart_splits.swap_buf_down },
          { '<leader><leader>k', smart_splits.swap_buf_up },
          { '<leader><leader>l', smart_splits.swap_buf_right },

          -- Clear highlighted search result
          { '<ESC>', ':noh<CR><ESC>' },

          -- Some plugin mappings that don't need to show
          { '<C-/>', function() Snacks.terminal() end, desc = 'Toggle Terminal' },
          { '<C-p>', function() Snacks.picker.files() end, desc = 'Find Files' },
          { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep' },
          { '<leader>*', function() Snacks.picker.grep_word() end, desc = 'Grep Selection', mode = 'nx' },
          { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
          { '<leader>nn', function() require('oil').toggle_float(nil) end, desc = 'File Browser' },
          { '<leader>qq', function() require('quicker').toggle({ focus = true }) end, desc = 'Quickfix' },

          -- Repeat movement
          { ';',       ts_repeat_move.repeat_last_move,          desc = 'TS - repeat last move',                       mode = 'nxo' },
          { '<space>', ts_repeat_move.repeat_last_move_opposite, desc = 'TS - repeat last move in opposite direction', mode = 'nxo' },
        },

        -- snacks.nvim
        {
          { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
          { '<leader>s"', function() Snacks.picker.registers() end,  desc = 'Registers' },
          { '<leader>s/', function() Snacks.picker.search_history() end,  desc = 'Search history' },
          { '<leader>sD', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
          { '<leader>sb', function() Snacks.picker.buffers() end,  desc = 'Buffers' },
          { '<leader>sc', function() Snacks.picker.command_history() end,  desc = 'Command history' },
          { '<leader>sd', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
          { '<leader>sk', function() Snacks.picker.keymaps() end,  desc = 'Keymaps' },
          { '<leader>sl', function() Snacks.picker.loclist() end, desc = 'Location List' },
          { '<leader>sq', function() Snacks.picker.qflist() end,  desc = 'Quickfix List' },
          { '<leader>sr', function() Snacks.picker.resume() end,  desc = 'Resume' },
        },

        -- Git
        {
          { '<leader>gs', require('neogit').open, desc = 'Status' },
          { '<leader>gb', '<cmd>Neogit branch<cr>', desc = 'Branch' },
          { '<leader>gc', '<cmd>Neogit commit<cr>', desc = 'Commit' },
          { '<leader>gl', '<cmd>Neogit log<cr>', desc = 'Log' },
          { '<leader>gp', '<cmd>Neogit pull<cr>', desc = 'Pull' },
          { '<leader>gP', '<cmd>Neogit push<cr>', desc = 'Push' },
          { '<leader>gB', '<cmd>Gitsign blame<cr>', desc = 'Blame' },
          { '<leader>gO', function() Snacks.gitbrowse() end, desc = 'Open Browser', mode = 'nv' },
          { '<leader>gg', function() Snacks.lazygit() end, desc = 'lazygit' },
        },

        -- Flash
        {
          { 's',     flash.jump,              desc = 'Flash',                   mode = 'nxo' },
          { 'S',     flash.treesitter,        desc = 'Flash Treesitter',        mode = 'nxo' },
          { 'r',     flash.remote,            desc = 'Remote Flash',            mode = 'o'   },
          { 'R',     flash.treesitter_search, desc = 'Remote Flash Treesitter', mode = 'xo'  },
          { '<c-s>', flash.toggle,            desc = 'Toggle Flash',            mode = 'c'   },
        },
      }
    end,
  },
}
