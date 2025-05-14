local wk = require('which-key')
local set_keymap = vim.keymap.set
local desc = function(description)
    return {
      noremap = true,
      silent = true,
      nowait = true,
      desc = description,
    }
end
local opts = desc(nil)


wk.add {
  {
    hidden = true,
    -- Quick shortcut for splittling
    { mode = 'n', '<C-W>-', ':split<CR>' },
    { mode = 'n', '<C-W>\\', ':vsplit<CR>' },

    -- Break undo sequence to smaller chunks
    { mode = 'i', '.', '.<C-g>u' },
    { mode = 'i', '?', '?<C-g>u' },
    { mode = 'i', '!', '!<C-g>u' },
    { mode = 'i', ',', ',<C-g>u' },

    -- Moving between windows
    { mode = 'n', '<A-h>', '<C-w>h' },
    { mode = 'n', '<A-j>', '<C-w>j' },
    { mode = 'n', '<A-k>', '<C-w>k' },
    { mode = 'n', '<A-l>', '<C-w>l' },

    -- Clear highlighted search result
    { mode = 'n', '<ESC>', ':noh<CR><ESC>' },

    -- Some plugin mappings that don't need to show
    { mode = 'n', '<C-p>', '<cmd>Telescope frecency workspace=CWD<cr>', desc = 'Find files' },
    { mode = 'n', '<leader>/', '<cmd>Telescope live_grep_args<cr>', desc = 'Live grep' },
    { mode = 'n', '<leader>*', '<cmd>Telescope grep_string<cr>', desc = 'Grep string' },
    { mode = 'n', '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
  },
}


-- hop.nvim
local hop_prefix = '<leader><leader>'
local HopChar1CurrentLineAC = '<cmd>HopChar1CurrentLineAC<cr>'
local HopChar1CurrentLineBC = '<cmd>HopChar1CurrentLineBC<cr>'
local HopWordCurrentLineAC = '<cmd>HopWordCurrentLineAC<cr>'
local HopWordCurrentLineBC = '<cmd>HopWordCurrentLineBC<cr>'
local HopChar1CurrentLineAC_inclusive_jump = '<cmd>lua require\'hop\'.hint_char1({ direction = require\'hop.hint\'.HintDirection.AFTER_CURSOR, inclusive_jump = true })<cr>'
local HopChar1CurrentLineBC_inclusive_jump = '<cmd>lua require\'hop\'.hint_char1({ direction = require\'hop.hint\'.HintDirection.BEFORE_CURSOR, inclusive_jump = true })<cr>'

set_keymap('', hop_prefix..'t', HopChar1CurrentLineAC, opts)
set_keymap('', hop_prefix..'T', HopChar1CurrentLineBC, opts)
set_keymap('n', hop_prefix..'f', HopChar1CurrentLineAC, opts)
set_keymap('n', hop_prefix..'F', HopChar1CurrentLineBC, opts)
set_keymap('n', hop_prefix..'w', HopWordCurrentLineAC, opts)
set_keymap('n', hop_prefix..'W', HopWordCurrentLineBC, opts)
set_keymap('o', hop_prefix..'f', HopChar1CurrentLineAC_inclusive_jump, opts)
set_keymap('o', hop_prefix..'F', HopChar1CurrentLineBC_inclusive_jump, opts)


-- telescope.nvim
wk.add {
  { '<leader>t', group = 'Telescope' },
  { '<leader>tb', '<cmd>Telescope buffers<cr>',  desc = 'Buffers' },
  { '<leader>tc', '<cmd>Telescope quickfix<cr>',  desc = 'Quickfix' },
  { '<leader>tr', '<cmd>Telescope resume<cr>',  desc = 'Resume' },
  { '<leader>tF', '<cmd>Telescope frecency<cr>',  desc = 'Previously opened files' },
  { '<leader>tq', '<cmd>Telescope command_history<cr>',  desc = 'Command history' },
  { '<leader>t/', '<cmd>Telescope search_history<cr>',  desc = 'Search history' },
}


-- gp.nvim
wk.add {
  {'<leader>u', group = 'GPT Prompt'},
  {'<leader>ug', '<cmd>GpChatToggle popup<cr>', desc = 'Toggle Chat'},
  {'<leader>ur', '<cmd>GpChatRespond<cr>', desc = 'Respond'},
  {'<leader>un', '<cmd>GpChatNew popup<cr>', desc = 'New Chat'},
}


-- Git
wk.add {
  { '<leader>g', group = 'Git' },
  { '<leader>gb', '<cmd>Telescope git_branches<cr>', desc = 'branches' },
  { '<leader>gs', '<cmd>Telescope git_status<cr>', desc = 'status' },
  { '<leader>gS', '<cmd>Telescope git_stash<cr>', desc = 'stash' },
  { '<leader>gg', function() Snacks.lazygit() end, desc = 'lazygit' },
  {
    mode = { 'n', 'v' },
    '<leader>gB',
    function() Snacks.gitbrowse() end,
    desc = 'Git Browse'
  },
}
