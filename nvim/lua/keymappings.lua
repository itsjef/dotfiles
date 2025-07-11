local M = {}
local wk = require('which-key')
local smart_splits = require('smart-splits')


function M:setup()
  local hop_prefix = '<leader><leader>'
  local HopChar1CurrentLineAC = '<cmd>HopChar1CurrentLineAC<cr>'
  local HopChar1CurrentLineBC = '<cmd>HopChar1CurrentLineBC<cr>'
  local HopWordCurrentLineAC = '<cmd>HopWordCurrentLineAC<cr>'
  local HopWordCurrentLineBC = '<cmd>HopWordCurrentLineBC<cr>'

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
      { '<C-p>', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
      { '<leader>/', '<cmd>Telescope live_grep_args<cr>', desc = 'Live grep' },
      { '<leader>*', '<cmd>Telescope grep_string<cr>', desc = 'Grep string' },
      { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
      { '<leader>nn', function() if not MiniFiles.close() then MiniFiles.open() end end, desc = 'File Browser' },
      { hop_prefix..'t', HopChar1CurrentLineAC, mode = 'nvo' },
      { hop_prefix..'T', HopChar1CurrentLineBC, mode = 'nvo' },
      { hop_prefix..'f', HopChar1CurrentLineAC },
      { hop_prefix..'F', HopChar1CurrentLineBC },
      { hop_prefix..'w', HopWordCurrentLineAC },
      { hop_prefix..'W', HopWordCurrentLineBC },
    },

    -- Close quickfix list
    { '<leader>co', ':copen<cr>', desc = 'Open quickfix list' },
    { '<leader>cq', ':cclose<cr>', desc = 'Close quickfix list' },

    -- telescope.nvim
    {
      { '<leader>t', group = 'Telescope' },
      { '<leader>tb', '<cmd>Telescope buffers<cr>',  desc = 'Buffers' },
      { '<leader>tc', '<cmd>Telescope quickfix<cr>',  desc = 'Quickfix' },
      { '<leader>tr', '<cmd>Telescope resume<cr>',  desc = 'Resume' },
      { '<leader>tF', '<cmd>Telescope frecency<cr>',  desc = 'Previously opened files' },
      { '<leader>tq', '<cmd>Telescope command_history<cr>',  desc = 'Command history' },
      { '<leader>t/', '<cmd>Telescope search_history<cr>',  desc = 'Search history' },
    },

    -- Git
    {
      { '<leader>g', group = 'Git' },
      { '<leader>gs', require('neogit').open, desc = 'Status' },
      { '<leader>gc', '<cmd>Neogit commit<cr>', desc = 'Commit' },
      { '<leader>gl', '<cmd>Neogit pull<cr>', desc = 'Pull' },
      { '<leader>gp', '<cmd>Neogit push<cr>', desc = 'Push' },
      { '<leader>gL', '<cmd>Neogit log<cr>', desc = 'Push' },
      { '<leader>gb', '<cmd>Telescope git_branches<cr>', desc = 'Branches' },
      { '<leader>gS', '<cmd>Telescope git_stash<cr>', desc = 'Stash' },
      { '<leader>gB', '<cmd>Gitsign blame<cr>', desc = 'Blame' },
      { '<leader>gO', function() Snacks.gitbrowse() end, desc = 'Open Browser', mode = 'nv' },
      { '<leader>gg', function() Snacks.lazygit() end, desc = 'lazygit' },
    },

    -- AI Assistant
    -- ...
  }
end


function M:lsp_keys(_)
  local lsp = vim.lsp
  local builtin = require('telescope.builtin')

  wk.add {
    { 'K', lsp.buf.hover, desc = 'Show Documentation' },
    { 'gO', builtin.lsp_document_symbols, desc = 'Show Symb[O]ls in current buffer' },
    { 'gd', builtin.lsp_definitions, desc = 'Go to [d]efinition' },
    { 'gi', builtin.lsp_implementations, desc = 'Go to [i]mplementation' },
    { 'gr', builtin.lsp_references, desc = 'Show [r]eferences' },
    { '<C-h>', lsp.buf.signature_help, desc = 'Show signature [h]elp', mode = 'i' },
    -- format, rename, code action, etc.
    { '<leader>=', lsp.buf.format, desc = 'Format' },
    { '<leader>ca', lsp.buf.code_action, desc = 'Code Action', mode = 'nv' },
    { '<leader>rn', lsp.buf.rename, desc = 'Rename' },
    -- diagnostics
    { '<leader>e', function() vim.diagnostic.open_float(nil, { border = 'rounded' }) end, desc = 'Show diagnostic [e]rror inline' },
    { '<leader>dq', builtin.diagnostics, desc = 'Add diagnostics to a [q]uickfix list' },
    -- workspace
    { '<leader>wa', lsp.buf.add_workspace_folder, desc = '[a]dd workspace folder' },
    { '<leader>wr', lsp.buf.remove_workspace_folder, desc = '[r]emove workspace folder' },
    { '<leader>wl', function() print(vim.inspect(lsp.buf.list_workspace_folders())) end, desc = '[l]ist workspace folders' },
    { '<leader>ws', builtin.lsp_workspace_symbols, desc = 'query workspace [s]ymbols' },
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
