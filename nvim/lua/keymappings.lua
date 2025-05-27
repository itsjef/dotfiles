local M = {}
local wk = require('which-key')


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

      -- Moving between windows
      { '<A-h>', '<C-w>h' },
      { '<A-j>', '<C-w>j' },
      { '<A-k>', '<C-w>k' },
      { '<A-l>', '<C-w>l' },

      -- Clear highlighted search result
      { '<ESC>', ':noh<CR><ESC>' },

      -- Some plugin mappings that don't need to show
      { '<C-/>', function() Snacks.terminal() end, desc = 'Toggler Terminal' },
      { '<C-p>', '<cmd>Telescope frecency workspace=CWD<cr>', desc = 'Find files' },
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
    {
      { '<leader>a', group = 'AI Assistant' },
      { '<leader>aa', '<cmd>CodeCompanionActions<cr>', desc = '[A]ctions' },
      { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle [C]hat' },
      { '<leader>an', '<cmd>CodeCompanionChat<cr>', desc = '[N]ew Chat' },
      { '<leader>ae', '<cmd>CodeCompanion /explain<cr>', desc = '[E]xplain Code', mode = 'v' },
      { '<leader>ar', '<cmd>CodeCompanion /review<cr>', desc = '[R]eview Code', mode = 'v' },
      { '<leader>af', '<cmd>CodeCompanion /fix<cr>', desc = '[F]ix Code', mode = 'v' },
      { '<leader>at', '<cmd>CodeCompanion /tests<cr>', desc = 'Generate [T]ests', mode = 'v' },
      { '<leader>ad', '<cmd>CodeCompanion /doc<cr>', desc = '[D]ocument Code', mode = 'v' },
      { '<leader>aq', '<cmd>CodeCompanion<cr>', desc = 'Quick [Q]uestion', mode = 'nv' },
      { '<leader>ap', '<cmd>CodeCompanionChat Add<cr>', desc = '[A]dd to Chat', mode = 'v' },
    },
  }
end


function M:lsp_keys(_)
  local lsp = vim.lsp

  wk.add {
    { '<leader>=', lsp.buf.format, desc = 'Lsp Format' },
    { '<leader>ca', lsp.buf.code_action, desc = 'Code Action' },
    { '<leader>rn', lsp.buf.rename, desc = 'Lsp Rename' },
    -- { '<leader>wa', lsp.buf.add_workspace_folder, desc = 'Add Workspace Folder' },
    -- { '<leader>wl', function() print(vim.inspect(lsp.buf.list_workspace_folders)) end, desc = 'Show Workspace Folders' },
    -- { '<leader>wr', lsp.buf.remove_workspace_folder, desc = 'Remove Workspace Folder' },
    -- { '<leader>wS', lsp.buf.workspace_symbol, desc = 'Show Workspace Symbol' },
    { 'K', lsp.buf.hover, desc = 'Show Documentation' },
    { 'gD', lsp.buf.declaration, desc = 'Go to Declaration' },
    { 'gK', lsp.buf.signature_help, desc = 'Signature Help' },
    { 'gO', lsp.buf.document_symbol, desc = 'Show Document Symbols' },
    { 'gd', lsp.buf.definition, desc = 'Go to Definition' },
    { 'gi', lsp.buf.implementation, desc = 'Go to Implementation' },
    { 'gr', lsp.buf.references, desc = 'Show References' },
    { 'gy', lsp.buf.type_definition, desc = 'Go to Type Definition' },
    { '[d', vim.diagnostic.goto_prev, desc = 'Diagnostic backward' },
    { ']d', vim.diagnostic.goto_next, desc = 'Diagnostic forward' },
    { '<leader>e', vim.diagnostic.open_float, desc = 'Show Diagnostic (inline)' },
    { '<leader>q', vim.diagnostic.setqflist, desc = 'Diagnostic qflist' },
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
