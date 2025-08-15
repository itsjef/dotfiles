local M = {}
local wk = require('which-key')
local smart_splits = require('smart-splits')


function M:setup()
  wk.add {
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
      { '<leader>nn', function() Snacks.explorer() end, desc = 'File Browser' },
      { '<leader>qq', function() require('quicker').toggle({ focus = true }) end, desc = 'Quickfix' },
    },

    -- snacks.nvim
    {
      { '<leader>s', group = 'Snacks Pickers' },
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
      { '<leader>g', group = 'Git' },
      { '<leader>gs', require('neogit').open, desc = 'Status' },
      { '<leader>gb', '<cmd>Neogit branch<cr>', desc = 'Branch' },
      { '<leader>gc', '<cmd>Neogit commit<cr>', desc = 'Commit' },
      { '<leader>gl', '<cmd>Neogit pull<cr>', desc = 'Pull' },
      { '<leader>gp', '<cmd>Neogit push<cr>', desc = 'Push' },
      { '<leader>gL', '<cmd>Neogit log<cr>', desc = 'Log' },
      { '<leader>gB', '<cmd>Gitsign blame<cr>', desc = 'Blame' },
      { '<leader>gO', function() Snacks.gitbrowse() end, desc = 'Open Browser', mode = 'nv' },
      { '<leader>gg', function() Snacks.lazygit() end, desc = 'lazygit' },
    },
  }
end


function M:lsp_keys(_)
  local lsp = vim.lsp

  wk.add {
    { 'K', lsp.buf.hover, desc = 'Show Documentation' },
    { 'gO', function() Snacks.picker.lsp_symbols() end, desc = 'Show LSP Symbols' },
    { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Go to Type Definition' },
    { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Go to Definition' },
    { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Go to Declaration' },
    { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Go to Implementation' },
    { 'gr', function() Snacks.picker.lsp_references() end, desc = 'Show References' },
    { '<C-h>', lsp.buf.signature_help, desc = 'Show signature [h]elp', mode = 'i' },
    -- format, rename, code action, etc.
    { '<leader>=', lsp.buf.format, desc = 'Format' },
    { '<leader>ca', lsp.buf.code_action, desc = 'Code Action', mode = 'nv' },
    { '<leader>rn', lsp.buf.rename, desc = 'Rename' },
    -- diagnostics
    { '<leader>e', function() vim.diagnostic.open_float(nil, { border = 'rounded' }) end, desc = 'Show diagnostic [e]rror inline' },
    -- workspace
    { '<leader>wa', lsp.buf.add_workspace_folder, desc = '[a]dd workspace folder' },
    { '<leader>wr', lsp.buf.remove_workspace_folder, desc = '[r]emove workspace folder' },
    { '<leader>wl', function() print(vim.inspect(lsp.buf.list_workspace_folders())) end, desc = '[l]ist workspace folders' },
    { '<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'Show LSP Workspace Symbols' },
  }
end


function M:gitsigns_keys(_)
  local gitsigns = require('gitsigns')

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
    { '<leader>hb', function() gitsigns.blame_line({ full = true }) end, desc = 'Git blame (current line)' },
    { '<leader>hS', gitsigns.stage_buffer, desc = 'Stage Buffer' },
    { '<leader>hR', gitsigns.reset_buffer, desc = 'Reset Buffer' },
    { '<leader>hp', gitsigns.preview_hunk, desc = 'Preview Hunk' },
    { '<leader>hi', gitsigns.preview_hunk_inline, desc = 'Preview Hunk (inline)' },
    { '<leader>hB', gitsigns.toggle_current_line_blame, desc = 'Toggle git blame (inline)' },
    { '<leader>hW', gitsigns.toggle_word_diff, desc = 'Toggle word diff' },
    -- { '<leader>hd', gitsigns.diffthis }
    -- { '<leader>hD', function() gitsigns.diffthis('~') end }
    -- { '<leader>hQ', function() gitsigns.setqflist('all') end }
    -- { '<leader>hq', gitsigns.setqflist }

    -- Text object
    { 'ih', gitsigns.select_hunk, mode = 'ox' },
  }
end


return M
