local M = {}

-- Lazy-call helper: returns a function that requires `mod` and calls `fn` only
-- when invoked. Avoids loading plugins at keymappings.lua module-load time so
-- lazy.nvim's event/cmd/keys triggers can do their job.
local function lazy(mod, fn)
  return function(...)
    return require(mod)[fn](...)
  end
end

local set = vim.keymap.set

local function ts_move(fn, query, ctx)
  return function() require('nvim-treesitter-textobjects.move')[fn](query, ctx) end
end
local function ts_sel(query, ctx)
  return function() require('nvim-treesitter-textobjects.select').select_textobject(query, ctx) end
end

function M:setup()
  -- Editor mechanics
  set('i', '.', '.<C-g>u')
  set('i', '?', '?<C-g>u')
  set('i', '!', '!<C-g>u')
  set('i', ',', ',<C-g>u')
  set('n', '<ESC>', ':noh<CR><ESC>')

  -- Window / split navigation
  set('n', '<C-W>-',            ':split<CR>')
  set('n', '<C-W>\\',           ':vsplit<CR>')
  set('n', '<C-h>',             lazy('smart-splits', 'resize_left'))
  set('n', '<C-j>',             lazy('smart-splits', 'resize_down'))
  set('n', '<C-k>',             lazy('smart-splits', 'resize_up'))
  set('n', '<C-l>',             lazy('smart-splits', 'resize_right'))
  set('n', '<A-h>',             lazy('smart-splits', 'move_cursor_left'))
  set('n', '<A-j>',             lazy('smart-splits', 'move_cursor_down'))
  set('n', '<A-k>',             lazy('smart-splits', 'move_cursor_up'))
  set('n', '<A-l>',             lazy('smart-splits', 'move_cursor_right'))
  set('n', '<A-\\>',            lazy('smart-splits', 'move_cursor_previous'))
  set('n', '<leader><leader>h', lazy('smart-splits', 'swap_buf_left'),  { desc = 'Swap buffer left' })
  set('n', '<leader><leader>j', lazy('smart-splits', 'swap_buf_down'),  { desc = 'Swap buffer down' })
  set('n', '<leader><leader>k', lazy('smart-splits', 'swap_buf_up'),    { desc = 'Swap buffer up' })
  set('n', '<leader><leader>l', lazy('smart-splits', 'swap_buf_right'), { desc = 'Swap buffer right' })

  -- Telescope
  set('n', '<C-\\>',      lazy('telescope.builtin', 'buffers'))
  set('n', '<C-p>',       lazy('telescope.builtin', 'find_files'))
  set('n', '<leader>/',   function() require('telescope').extensions.live_grep_args.live_grep_args() end,                                          { desc = 'Grep' })
  set('n', "<leader>'",   function() require('telescope').extensions.live_grep_args.live_grep_args({ grep_open_files = true }) end,                { desc = 'Grep open buffers' })
  set({'n','x'}, '<leader>*', function() require('telescope-live-grep-args.shortcuts').grep_word_under_cursor() end,                               { desc = 'Grep word under cursor' })
  set('n', '<leader><space>', lazy('telescope.builtin', 'find_files'),                                    { desc = 'Find Files' })
  set('n', '<leader>f"',      lazy('telescope.builtin', 'registers'),                                     { desc = 'Registers' })
  set('n', '<leader>f/',      lazy('telescope.builtin', 'search_history'),                                { desc = 'Search history' })
  set('n', '<leader>fD',      lazy('telescope.builtin', 'diagnostics'),                                   { desc = 'Diagnostics' })
  set('n', '<leader>fc',      lazy('telescope.builtin', 'command_history'),                               { desc = 'Command history' })
  set('n', '<leader>fd',      function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end,     { desc = 'Buffer Diagnostics' })
  set('n', '<leader>fk',      lazy('telescope.builtin', 'keymaps'),                                       { desc = 'Keymaps' })
  set('n', '<leader>fl',      lazy('telescope.builtin', 'loclist'),                                       { desc = 'Location List' })
  set('n', '<leader>fq',      lazy('telescope.builtin', 'quickfix'),                                      { desc = 'Quickfix List' })
  set('n', '<leader>fr',      lazy('telescope.builtin', 'resume'),                                        { desc = 'Resume' })

  -- Buffers / files / quickfix
  set('n', '<leader>bd', lazy('mini.bufremove', 'delete'),                           { desc = 'Delete Buffer' })
  set('n', '<leader>nn', function() require('oil').toggle_float(nil) end,             { desc = 'File Browser' })
  set('n', '<leader>qq', function() require('quicker').toggle({ focus = true }) end,  { desc = 'Quickfix' })

  -- Git
  set('n', '<leader>gs', '<cmd>Neogit<cr>',                { desc = 'Open Neogit UI' })
  set('n', '<leader>gb', '<cmd>Neogit branch<cr>',         { desc = 'Branch' })
  set('n', '<leader>gc', '<cmd>Neogit commit<cr>',         { desc = 'Commit' })
  set('n', '<leader>gl', '<cmd>Neogit log<cr>',            { desc = 'Log' })
  set('n', '<leader>gp', '<cmd>Neogit pull<cr>',           { desc = 'Pull' })
  set('n', '<leader>gr', '<cmd>Neogit rebase<cr>',         { desc = 'Rebase' })
  set('n', '<leader>gP', '<cmd>Neogit push<cr>',           { desc = 'Push' })
  set('n', '<leader>gB', '<cmd>Gitsign blame<cr>',         { desc = 'Blame' })
  set({'n','v'}, '<leader>gO', lazy('gitportal', 'to_remote'), { desc = 'Open in Browser' })

  -- AI / Claude Code
  set('n', '<leader>ac', '<cmd>ClaudeCode<cr>',            { desc = 'Toggle Claude' })
  set('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>',       { desc = 'Focus Claude' })
  set('n', '<leader>ar', '<cmd>ClaudeCode --resume<cr>',   { desc = 'Resume Claude' })
  set('n', '<leader>aC', '<cmd>ClaudeCode --continue<cr>', { desc = 'Continue Claude' })
  set('n', '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', { desc = 'Select Model' })
  set('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>',       { desc = 'Add current buffer' })
  set('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>',        { desc = 'Send to Claude' })
  set('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>',  { desc = 'Accept diff' })
  set('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>',    { desc = 'Deny diff' })

  -- Treesitter text objects
  set({'n','x','o'}, ']]', ts_move('goto_next_start',    '@class.outer',    'textobjects'), { desc = 'next Class start' })
  set({'n','x','o'}, '][', ts_move('goto_next_end',      '@class.outer',    'textobjects'), { desc = 'next Class end' })
  set({'n','x','o'}, '[[', ts_move('goto_previous_start','@class.outer',    'textobjects'), { desc = 'prev Class start' })
  set({'n','x','o'}, '[]', ts_move('goto_previous_end',  '@class.outer',    'textobjects'), { desc = 'prev Class end' })
  set({'n','x','o'}, ']m', ts_move('goto_next_start',    '@function.outer', 'textobjects'), { desc = 'next Function start' })
  set({'n','x','o'}, ']M', ts_move('goto_next_end',      '@function.outer', 'textobjects'), { desc = 'next Function end' })
  set({'n','x','o'}, '[m', ts_move('goto_previous_start','@function.outer', 'textobjects'), { desc = 'prev Function start' })
  set({'n','x','o'}, '[M', ts_move('goto_previous_end',  '@function.outer', 'textobjects'), { desc = 'prev Function end' })
  set({'n','x','o'}, ']s', ts_move('goto_next_start',    '@local.scope',    'locals'),      { desc = 'next Scope start' })
  set({'n','x','o'}, '[s', ts_move('goto_previous_start','@local.scope',    'locals'),      { desc = 'prev Scope start' })
  set({'o','x'}, 'am', ts_sel('@function.outer', 'textobjects'), { desc = 'select Function outer' })
  set({'o','x'}, 'im', ts_sel('@function.inner', 'textobjects'), { desc = 'select Function inner' })
  set({'o','x'}, 'ac', ts_sel('@class.outer',    'textobjects'), { desc = 'select Class outer' })
  set({'o','x'}, 'ic', ts_sel('@class.inner',    'textobjects'), { desc = 'select Class inner' })
  set({'o','x'}, 'as', ts_sel('@local.scope',    'locals'),      { desc = 'select Local scope' })

  -- Filetype-specific keymaps (buffer-local)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'oil', 'netrw' },
    callback = function(ev)
      set('n', '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', { buffer = ev.buf, desc = 'Add file' })
      require('mini.clue').ensure_buf_triggers(ev.buf)
    end,
  })
end

function M:lsp_keys(_)
  local lsp = vim.lsp

  set('n',        'K',           lsp.buf.hover,                                                        { desc = 'Show Documentation' })
  set('n',        'gO',          lazy('telescope.builtin', 'lsp_document_symbols'),                    { desc = 'Show LSP Symbols' })
  set('n',        'gy',          lazy('telescope.builtin', 'lsp_type_definitions'),                    { desc = 'Go to Type Definition' })
  set('n',        'gd',          lazy('telescope.builtin', 'lsp_definitions'),                         { desc = 'Go to Definition' })
  set('n',        'gD',          lazy('telescope.builtin', 'lsp_declarations'),                        { desc = 'Go to Declaration' })
  set('n',        'gI',          lazy('telescope.builtin', 'lsp_implementations'),                     { desc = 'Go to Implementation' })
  set('n',        'gr',          lazy('telescope.builtin', 'lsp_references'),                          { desc = 'Show References' })
  set('i',        '<C-h>',       lsp.buf.signature_help,                                               { desc = 'Show signature help' })
  set('n',        '<leader>=',   lsp.buf.format,                                                       { desc = 'Format' })
  set({'n','v'},  '<leader>ca',  lsp.buf.code_action,                                                  { desc = 'Code Action' })
  set('n',        '<leader>rn',  lsp.buf.rename,                                                       { desc = 'Rename' })
  set('n',        '<leader>e',   function() vim.diagnostic.open_float(nil, { border = 'rounded' }) end, { desc = 'Show diagnostic error inline' })
  set('n',        '<leader>wa',  lsp.buf.add_workspace_folder,                                         { desc = 'Add workspace folder' })
  set('n',        '<leader>wr',  lsp.buf.remove_workspace_folder,                                      { desc = 'Remove workspace folder' })
  set('n',        '<leader>wl',  function() print(vim.inspect(lsp.buf.list_workspace_folders())) end,  { desc = 'List workspace folders' })
  set('n',        '<leader>ws',  lazy('telescope.builtin', 'lsp_workspace_symbols'),                   { desc = 'Show LSP Workspace Symbols' })
end

function M:gitsigns_keys(_)
  local gitsigns = require('gitsigns')

  -- Navigation
  set('n', ']c', function()
    if vim.wo.diff then
      vim.cmd.normal({ ']c', bang = true })
    else
      gitsigns.nav_hunk('next')
    end
  end, { desc = 'next git change' })

  set('n', '[c', function()
    if vim.wo.diff then
      vim.cmd.normal({ '[c', bang = true })
    else
      gitsigns.nav_hunk('prev')
    end
  end, { desc = 'prev git change' })

  -- Actions
  set('n', '<leader>hs', gitsigns.stage_hunk,                                                        { desc = 'Stage Hunk' })
  set('n', '<leader>hr', gitsigns.reset_hunk,                                                        { desc = 'Reset Hunk' })
  set('v', '<leader>hs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Stage Hunk (selection)' })
  set('v', '<leader>hr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Reset Hunk (selection)' })
  set('n', '<leader>hb', function() gitsigns.blame_line({ full = true }) end,                        { desc = 'Blame (current line)' })
  set('n', '<leader>hS', gitsigns.stage_buffer,                                                      { desc = 'Stage Buffer' })
  set('n', '<leader>hR', gitsigns.reset_buffer,                                                      { desc = 'Reset Buffer' })
  set('n', '<leader>hp', gitsigns.preview_hunk,                                                      { desc = 'Preview Hunk' })
  set('n', '<leader>hi', gitsigns.preview_hunk_inline,                                               { desc = 'Preview Hunk (inline)' })
  set('n', '<leader>hB', gitsigns.toggle_current_line_blame,                                         { desc = 'Blame (inline)' })

  -- Text object
  set({'o','x'}, 'ih', gitsigns.select_hunk)
end

return M
