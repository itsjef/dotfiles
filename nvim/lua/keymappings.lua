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


-- Quick shortcut for splittling
set_keymap('n', '<C-W>-', ':split<CR>', opts)
set_keymap('n', '<C-W>\\', ':vsplit<CR>', opts)


-- Break undo sequence to smaller chunks
set_keymap('i', '.', '.<C-g>u', opts)
set_keymap('i', '?', '?<C-g>u', opts)
set_keymap('i', '!', '!<C-g>u', opts)
set_keymap('i', ',', ',<C-g>u', opts)


-- Moving between windows
set_keymap('n', '<A-h>', '<C-w>h', opts)
set_keymap('n', '<A-j>', '<C-w>j', opts)
set_keymap('n', '<A-k>', '<C-w>k', opts)
set_keymap('n', '<A-l>', '<C-w>l', opts)


-- Clear highlighted search result
set_keymap('n', '<ESC>', ':noh<CR><ESC>', opts)


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
set_keymap('n', '<C-p>', '<cmd>Telescope frecency workspace=CWD<cr>', desc('Find files'))
set_keymap('n', '<leader>/', '<cmd>Telescope live_grep_args<cr>', desc('Live grep'))
set_keymap('n', '<leader>*', '<cmd>Telescope grep_string<cr>', desc('Grep string'))
set_keymap('n', '<leader>tb', '<cmd>Telescope buffers<cr>', desc('Buffers'))
set_keymap('n', '<leader>tr', '<cmd>Telescope resume<cr>', desc('Resume Telescope'))
set_keymap('n', '<leader>tF', '<cmd>Telescope frecency<cr>', desc('Previously opened files'))
set_keymap('n', '<leader>tq', '<cmd>Telescope command_history<cr>', desc('Command history'))
set_keymap('n', '<leader>t/', '<cmd>Telescope search_history<cr>', desc('Search history'))
-- git
set_keymap('n', '<leader>gb', '<cmd>Telescope git_branches<cr>', desc('Git branches'))
set_keymap('n', '<leader>gs', '<cmd>Telescope git_status<cr>', desc('Git status'))
set_keymap('n', '<leader>gS', '<cmd>Telescope git_stash<cr>', desc('Git stash'))


-- gp.nvim
set_keymap('n', '<leader>ug', '<cmd>GpChatToggle popup<cr>', desc('GPT Prompt - Toggle Chat'))
set_keymap('n', '<leader>ur', '<cmd>GpChatRespond<cr>', desc('GPT Prompt - Respond'))
set_keymap('n', '<leader>un', '<cmd>GpChatNew popup<cr>', desc('GPT Prompt - New Chat'))


-- snacks.nvim
set_keymap('n', '<leader>bd', function() Snacks.bufdelete() end, desc('Delete Buffer'))
set_keymap({ 'n', 'v' }, '<leader>gB', function() Snacks.gitbrowse() end, desc('Git Browse'))
set_keymap('n', '<leader>gg', function() Snacks.lazygit() end, desc('Lazygit'))


-- lsp & lspsaga
-- remap default LSP keys with lspsaga
set_keymap('n', 'grn', '<cmd>Lspsaga rename<cr>', opts)
set_keymap('n', 'gra', '<cmd>Lspsaga code_action<cr>', opts)
set_keymap('n', 'grr', '<cmd>Lspsaga finder ref<cr>', opts)
set_keymap('n', 'gri', '<cmd>Lspsaga finder imp<cr>', opts)
set_keymap('n', 'gO', '<cmd>Lspsaga outline<cr>', opts)
set_keymap('n', 'K', '<cmd>Lspsaga hover_doc<cr>', opts)
set_keymap('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<cr>', opts)
set_keymap('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<cr>', opts)
-- other lsp/lspsaga mappings
set_keymap('n', '<leader>=', vim.lsp.buf.format, opts)
set_keymap('n', '<leader>e', '<cmd>Lspsaga show_line_diagnostics<cr>', opts)
set_keymap('n', '<leader>q', '<cmd>Lspsaga show_buf_diagnostics<cr>', opts)
