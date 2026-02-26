local M = {}
local wk = require('which-key')
local smart_splits = require('smart-splits')
local ts_move = require('nvim-treesitter-textobjects.move')

function M:setup()
  wk.add {
    -- groups
    { '<leader>a', group = 'AI/Claude Code' },
    { '<leader>g', group = 'Neogit' },
    { '<leader>h', group = 'Markdown and Gitsigns' },
    { '<leader>m', group = 'Markdown (the rest)' },
    { '<leader>s', group = 'Snacks Pickers' },

    -- hidden key mappings
    {
      hidden = true,
      -- Quick shortcut for splittling
      { '<C-W>-',            ':split<CR>' },
      { '<C-W>\\',           ':vsplit<CR>' },

      -- Break undo sequence to smaller chunks
      { '.',                 '.<C-g>u',                                                  mode = 'i' },
      { '?',                 '?<C-g>u',                                                  mode = 'i' },
      { '!',                 '!<C-g>u',                                                  mode = 'i' },
      { ',',                 ',<C-g>u',                                                  mode = 'i' },

      -- smart-splits
      -- resizing splits
      -- these keymaps will also accept a range,
      -- for example `10<C-h>` will `resize_left` by `(10 * config.default_amount)`
      { '<C-h>',             smart_splits.resize_left },
      { '<C-j>',             smart_splits.resize_down },
      { '<C-k>',             smart_splits.resize_up },
      { '<C-l>',             smart_splits.resize_right },
      -- moving between splits
      { '<A-h>',             smart_splits.move_cursor_left },
      { '<A-j>',             smart_splits.move_cursor_down },
      { '<A-k>',             smart_splits.move_cursor_up },
      { '<A-l>',             smart_splits.move_cursor_right },
      { '<A-\\>',            smart_splits.move_cursor_previous },
      -- swapping buffers between windows
      { '<leader><leader>h', smart_splits.swap_buf_left },
      { '<leader><leader>j', smart_splits.swap_buf_down },
      { '<leader><leader>k', smart_splits.swap_buf_up },
      { '<leader><leader>l', smart_splits.swap_buf_right },

      -- Clear highlighted search result
      { '<ESC>',             ':noh<CR><ESC>' },

      -- Some plugin mappings that don't need to show
      { '<C-/>',             function() Snacks.terminal() end,                           desc = 'Toggle Terminal' },
      { '<C-\\>',            function() Snacks.picker.buffers() end,                     desc = 'Buffers' },
      { '<C-p>',             function() Snacks.picker.files() end,                       desc = 'Find Files' },
      { '<leader>/',         function() Snacks.picker.grep() end,                        desc = 'Grep' },
      { '<leader>\'',        function() Snacks.picker.grep_buffers() end,                desc = 'Grep Open Buffers' },
      { '<leader>*',         function() Snacks.picker.grep_word() end,                   desc = 'Grep Selection',   mode = 'nx' },
      { '<leader>bd',        function() Snacks.bufdelete() end,                          desc = 'Delete Buffer' },
      { '<leader>nn',        function() require('oil').toggle_float(nil) end,            desc = 'File Browser' },
      { '<leader>qq',        function() require('quicker').toggle({ focus = true }) end, desc = 'Quickfix' },
    },

    -- snacks.nvim
    {
      { '<leader><space>', function() Snacks.picker.smart() end,              desc = 'Smart Find Files' },
      { '<leader>s"',      function() Snacks.picker.registers() end,          desc = 'Registers' },
      { '<leader>s/',      function() Snacks.picker.search_history() end,     desc = 'Search history' },
      { '<leader>sD',      function() Snacks.picker.diagnostics() end,        desc = 'Diagnostics' },
      { '<leader>sc',      function() Snacks.picker.command_history() end,    desc = 'Command history' },
      { '<leader>sd',      function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
      { '<leader>sk',      function() Snacks.picker.keymaps() end,            desc = 'Keymaps' },
      { '<leader>sl',      function() Snacks.picker.loclist() end,            desc = 'Location List' },
      { '<leader>sn',      function() Snacks.picker.notifications() end,      desc = 'Notification History' },
      { '<leader>sq',      function() Snacks.picker.qflist() end,             desc = 'Quickfix List' },
      { '<leader>sr',      function() Snacks.picker.resume() end,             desc = 'Resume' },
    },

    -- Git
    {
      { '<leader>gs', '<cmd>Neogit<cr>',                 desc = 'Open Neogit UI' },
      { '<leader>gb', '<cmd>Neogit branch<cr>',          desc = 'Branch' },
      { '<leader>gc', '<cmd>Neogit commit<cr>',          desc = 'Commit' },
      { '<leader>gl', '<cmd>Neogit log<cr>',             desc = 'Log' },
      { '<leader>gp', '<cmd>Neogit pull<cr>',            desc = 'Pull' },
      { '<leader>gr', '<cmd>Neogit rebase<cr>',          desc = 'Rebase' },
      { '<leader>gP', '<cmd>Neogit push<cr>',            desc = 'Push' },
      { '<leader>gB', '<cmd>Gitsign blame<cr>',          desc = 'Blame' },
      { '<leader>gO', function() Snacks.gitbrowse() end, desc = 'Open Browser',  mode = 'nv' },
    },

    -- which-key
    {
      { '<leader>?', function() require('which-key').show({ global = false }) end, desc = 'Buffer Local Keymaps (which-key)' },
    },

    -- Claude Code
    {
      { '<leader>ac', '<cmd>ClaudeCode<cr>',            desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>',       desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>',   desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>',       desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>',        desc = 'Send to Claude',     mode = 'v' },
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>',  desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>',    desc = 'Deny diff' },
    },

    -- Treesitter Text Objects
    {
      -- class
      { ']]', function() ts_move.goto_next_start('@class.outer', 'textobjects') end,        desc = 'next Class start',    mode = 'nxo' },
      { '][', function() ts_move.goto_next_end('@class.outer', 'textobjects') end,          desc = 'next Class end',      mode = 'nxo' },
      { '[[', function() ts_move.goto_previous_start('@class.outer', 'textobjects') end,    desc = 'prev Class start',    mode = 'nxo' },
      { '[]', function() ts_move.goto_previous_end('@class.outer', 'textobjects') end,      desc = 'prev Class end',      mode = 'nxo' },
      -- function
      { ']m', function() ts_move.goto_next_start('@function.outer', 'textobjects') end,     desc = 'next Function start', mode = 'nxo' },
      { ']M', function() ts_move.goto_next_end('@function.outer', 'textobjects') end,       desc = 'next Function end',   mode = 'nxo' },
      { '[m', function() ts_move.goto_previous_start('@function.outer', 'textobjects') end, desc = 'prev Function start', mode = 'nxo' },
      { '[M', function() ts_move.goto_previous_end('@function.outer', 'textobjects') end,   desc = 'prev Function end',   mode = 'nxo' },
    }
  }

  -- Filetype-specific keymaps (buffer-local)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'oil', 'netrw' },
    callback = function()
      wk.add {
        { '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Add file', buffer = 0 },
      }
    end,
  })
end

function M:lsp_keys(_)
  local lsp = vim.lsp

  wk.add {
    { 'K',          function() lsp.buf.hover() end,                                        desc = 'Show Documentation' },
    { 'gO',         function() Snacks.picker.lsp_symbols() end,                            desc = 'Show LSP Symbols' },
    { 'gy',         function() Snacks.picker.lsp_type_definitions() end,                   desc = 'Go to Type Definition' },
    { 'gd',         function() Snacks.picker.lsp_definitions() end,                        desc = 'Go to Definition' },
    { 'gD',         function() Snacks.picker.lsp_declarations() end,                       desc = 'Go to Declaration' },
    { 'gI',         function() Snacks.picker.lsp_implementations() end,                    desc = 'Go to Implementation' },
    { 'gr',         function() Snacks.picker.lsp_references() end,                         desc = 'Show References' },
    { '<C-h>',      lsp.buf.signature_help,                                                desc = 'Show signature [h]elp',         mode = 'i' },
    -- format, rename, code action, etc.
    { '<leader>=',  lsp.buf.format,                                                        desc = 'Format' },
    { '<leader>ca', lsp.buf.code_action,                                                   desc = 'Code Action',                   mode = 'nv' },
    { '<leader>rn', lsp.buf.rename,                                                        desc = 'Rename' },
    -- diagnostics
    { '<leader>e',  function() vim.diagnostic.open_float(nil, { border = 'rounded' }) end, desc = 'Show diagnostic [e]rror inline' },
    -- workspace
    { '<leader>wa', lsp.buf.add_workspace_folder,                                          desc = '[a]dd workspace folder' },
    { '<leader>wr', lsp.buf.remove_workspace_folder,                                       desc = '[r]emove workspace folder' },
    { '<leader>wl', function() print(vim.inspect(lsp.buf.list_workspace_folders())) end,   desc = '[l]ist workspace folders' },
    { '<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end,                  desc = 'Show LSP Workspace Symbols' },
  }
end

function M:gitsigns_keys(_)
  local gitsigns = require('gitsigns')

  wk.add {
    -- Navigation
    {
      ']c',
      function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end,
      desc = 'next git change',
    },
    {
      '[c',
      function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end,
      desc = 'prev git change',
    },

    -- Actions
    { '<leader>hs', gitsigns.stage_hunk,                                                        desc = 'Stage Hunk' },
    { '<leader>hr', gitsigns.reset_hunk,                                                        desc = 'Reset Hunk' },
    { '<leader>hs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = 'Stage Hunk (selection)', mode = 'v' },
    { '<leader>hr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = 'Reset Hunk (selection)', mode = 'v' },
    { '<leader>hb', function() gitsigns.blame_line({ full = true }) end,                        desc = 'Blame (current line)' },
    { '<leader>hS', gitsigns.stage_buffer,                                                      desc = 'Stage Buffer' },
    { '<leader>hR', gitsigns.reset_buffer,                                                      desc = 'Reset Buffer' },
    { '<leader>hp', gitsigns.preview_hunk,                                                      desc = 'Preview Hunk' },
    { '<leader>hi', gitsigns.preview_hunk_inline,                                               desc = 'Preview Hunk (inline)' },
    { '<leader>hB', gitsigns.toggle_current_line_blame,                                         desc = 'Blame (inline)' },
    -- { '<leader>hW', gitsigns.toggle_word_diff, desc = 'Toggle word diff' },
    -- { '<leader>hd', gitsigns.diffthis }
    -- { '<leader>hD', function() gitsigns.diffthis('~') end }
    -- { '<leader>hQ', function() gitsigns.setqflist('all') end }
    -- { '<leader>hq', gitsigns.setqflist }

    -- Text object
    { 'ih',         gitsigns.select_hunk,                                                       mode = 'ox' },
  }
end

return M
