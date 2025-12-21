vim.o.clipboard = 'unnamedplus' -- copy & paste from system clipboard
vim.o.hidden = true -- hide abandoned buffer
vim.o.mouse = 'a' -- enable mouse
vim.o.scrolloff = 999 -- Set lines to the cursor when moving around with j/k keys
vim.o.cursorline = true -- Display the line you are in
vim.o.number = true
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- Indentation
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = false

-- Line mark
vim.opt.list = true
vim.opt.listchars = {eol = '¬', nbsp = '+', tab = '> ', trail = '-'}


-- When searching try to be smart about cases
vim.o.ignorecase = true
vim.o.smartcase = true

-- 'Natural' splitting
vim.o.splitbelow = true
vim.o.splitright = true

-- Persistent undo - You can undo even after closing a buffer or Vim itself
vim.api.nvim_exec([[
  try
    set udir=$HOME/.config/nvim/temp_dir/undo
    set undofile
  catch
  endtry
]], false)

-- True color
vim.g.termguicolors = true

-- toggle relative line number on the basis of mode
local augroup = vim.api.nvim_create_augroup('numbertoggle', {})

vim.api.nvim_create_autocmd(
  { 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' },
  {
    pattern = '*',
    group = augroup,
    callback = function()
      if vim.o.nu and vim.api.nvim_get_mode().mode ~= 'i' then
        vim.opt.relativenumber = true
      end
    end,
  }
)

vim.api.nvim_create_autocmd(
  { 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' },
  {
    pattern = '*',
    group = augroup,
    callback = function()
      if vim.o.nu then
        vim.opt.relativenumber = false
        vim.cmd('redraw')
      end
    end,
  }
)

vim.api.nvim_create_autocmd(
  'FileType',
  {
    pattern = {
      'bash',
      'comment',
      'dockerfile',
      'html',
      'http',
      'latex',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'python',
      'regex',
      'scala',
      'toml',
      'typst',
      'vimdoc',
      'yaml,'
    },
    callback = function()
      -- TS highlighting
      vim.treesitter.start()
      -- TS indentation
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  }
)
