local wk = require('which-key')


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
    { '<leader>nn', function() MiniFiles.open() end, desc = 'File Browser' },
    { hop_prefix..'t', HopChar1CurrentLineAC, mode = 'nvo' },
    { hop_prefix..'T', HopChar1CurrentLineBC, mode = 'nvo' },
    { hop_prefix..'f', HopChar1CurrentLineAC },
    { hop_prefix..'F', HopChar1CurrentLineBC },
    { hop_prefix..'w', HopWordCurrentLineAC },
    { hop_prefix..'W', HopWordCurrentLineBC },
  },

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

  -- gp.nvim
  {
    { '<leader>u', group = 'GPT Prompt' },
    { '<leader>ug', '<cmd>GpChatToggle popup<cr>', desc = 'Toggle Chat' },
    { '<leader>ur', '<cmd>GpChatRespond<cr>', desc = 'Respond' },
    { '<leader>un', '<cmd>GpChatNew popup<cr>', desc = 'New Chat' },
  },

  -- Git
  {
    { '<leader>g', group = 'Git' },
    { '<leader>gs', require('neogit').open, desc = 'Status' },
    { '<leader>gc', '<cmd>Neogit commit<cr>', desc = 'Commit' },
    { '<leader>gl', '<cmd>Neogit pull<cr>', desc = 'Pull' },
    { '<leader>gp', '<cmd>Neogit push<cr>', desc = 'Push' },
    -- diffview?
    { '<leader>gb', '<cmd>Telescope git_branches<cr>', desc = 'Branches' },
    { '<leader>gS', '<cmd>Telescope git_stash<cr>', desc = 'Stash' },
    { '<leader>gB', '<cmd>Gitsign blame<cr>', desc = 'Blame' },
    { '<leader>gO', function() Snacks.gitbrowse() end, desc = 'Open Browser', mode = 'nv' },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'lazygit' },
  },
}
