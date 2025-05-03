local set_keymap = vim.keymap.set
local opts = { noremap = true, silent = true }


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
