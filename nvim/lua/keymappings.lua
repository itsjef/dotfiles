local M = {}

-- Lazy-call helper: returns a function that requires `mod` and calls `fn` only
-- when invoked. Avoids loading plugins at keymappings.lua module-load time so
-- lazy.nvim's event/cmd/keys triggers can do their job.
local function lazy(mod, fn)
  return function(...)
    return require(mod)[fn](...)
  end
end

function M:setup()
  local wk = require('which-key')

  wk.add {
    -- groups
    { '<leader>a', group = 'AI/Claude Code' },
    { '<leader>f', group = 'Telescope' },
    { '<leader>g', group = 'Neogit' },
    { '<leader>h', group = 'Markdown and Gitsigns' },
    { '<leader>m', group = 'Markdown (the rest)' },

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
      { '<C-h>',             lazy('smart-splits', 'resize_left') },
      { '<C-j>',             lazy('smart-splits', 'resize_down') },
      { '<C-k>',             lazy('smart-splits', 'resize_up') },
      { '<C-l>',             lazy('smart-splits', 'resize_right') },
      -- moving between splits
      { '<A-h>',             lazy('smart-splits', 'move_cursor_left') },
      { '<A-j>',             lazy('smart-splits', 'move_cursor_down') },
      { '<A-k>',             lazy('smart-splits', 'move_cursor_up') },
      { '<A-l>',             lazy('smart-splits', 'move_cursor_right') },
      { '<A-\\>',            lazy('smart-splits', 'move_cursor_previous') },
      -- swapping buffers between windows
      { '<leader><leader>h', lazy('smart-splits', 'swap_buf_left') },
      { '<leader><leader>j', lazy('smart-splits', 'swap_buf_down') },
      { '<leader><leader>k', lazy('smart-splits', 'swap_buf_up') },
      { '<leader><leader>l', lazy('smart-splits', 'swap_buf_right') },

      -- Clear highlighted search result
      { '<ESC>',             ':noh<CR><ESC>' },

      -- Some plugin mappings that don't need to show
      { '<C-\\>',     lazy('telescope.builtin', 'buffers'),                                         desc = 'Buffers' },
      { '<C-p>',      lazy('telescope.builtin', 'find_files'),                                      desc = 'Find Files' },
      { '<leader>/',  function() require('telescope').extensions.live_grep_args.live_grep_args() end, desc = 'Grep' },
      { '<leader>\'', function() require('telescope').extensions.live_grep_args.live_grep_args({ grep_open_files = true }) end, desc = 'Grep Open Buffers' },
      { '<leader>*',  function() require('telescope-live-grep-args.shortcuts').grep_word_under_cursor() end, desc = 'Grep Selection',   mode = 'nx' },
      { '<leader>bd', lazy('mini.bufremove', 'delete'),                                             desc = 'Delete Buffer' },
      { '<leader>nn', function() require('oil').toggle_float(nil) end,                              desc = 'File Browser' },
      { '<leader>qq', function() require('quicker').toggle({ focus = true }) end,                   desc = 'Quickfix' },
    },

    -- telescope.nvim
    {
      { '<leader><space>', lazy('telescope.builtin', 'find_files'),                                 desc = 'Find Files' },
      { '<leader>f"',      lazy('telescope.builtin', 'registers'),                                  desc = 'Registers' },
      { '<leader>f/',      lazy('telescope.builtin', 'search_history'),                             desc = 'Search history' },
      { '<leader>fD',      lazy('telescope.builtin', 'diagnostics'),                                desc = 'Diagnostics' },
      { '<leader>fc',      lazy('telescope.builtin', 'command_history'),                            desc = 'Command history' },
      { '<leader>fd',      function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end,  desc = 'Buffer Diagnostics' },
      { '<leader>fk',      lazy('telescope.builtin', 'keymaps'),                                    desc = 'Keymaps' },
      { '<leader>fl',      lazy('telescope.builtin', 'loclist'),                                    desc = 'Location List' },
      { '<leader>fq',      lazy('telescope.builtin', 'quickfix'),                                   desc = 'Quickfix List' },
      { '<leader>fr',      lazy('telescope.builtin', 'resume'),                                     desc = 'Resume' },
    },

    -- Git
    {
      { '<leader>gs', '<cmd>Neogit<cr>',                                  desc = 'Open Neogit UI' },
      { '<leader>gb', '<cmd>Neogit branch<cr>',                           desc = 'Branch' },
      { '<leader>gc', '<cmd>Neogit commit<cr>',                           desc = 'Commit' },
      { '<leader>gl', '<cmd>Neogit log<cr>',                              desc = 'Log' },
      { '<leader>gp', '<cmd>Neogit pull<cr>',                             desc = 'Pull' },
      { '<leader>gr', '<cmd>Neogit rebase<cr>',                           desc = 'Rebase' },
      { '<leader>gP', '<cmd>Neogit push<cr>',                             desc = 'Push' },
      { '<leader>gB', '<cmd>Gitsign blame<cr>',                           desc = 'Blame' },
      { '<leader>gO', lazy('gitportal', 'to_remote'),                     desc = 'Open Browser', mode = 'nv' },
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
      -- navigate class
      { ']]', function() require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects') end,        desc = 'next Class start',      mode = 'nxo' },
      { '][', function() require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects') end,          desc = 'next Class end',        mode = 'nxo' },
      { '[[', function() require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects') end,    desc = 'prev Class start',      mode = 'nxo' },
      { '[]', function() require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects') end,      desc = 'prev Class end',        mode = 'nxo' },
      -- navigate function
      { ']m', function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects') end,     desc = 'next Function start',   mode = 'nxo' },
      { ']M', function() require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects') end,       desc = 'next Function end',     mode = 'nxo' },
      { '[m', function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects') end, desc = 'prev Function start',   mode = 'nxo' },
      { '[M', function() require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects') end,   desc = 'prev Function end',     mode = 'nxo' },
      -- navigate scope
      { ']s', function() require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals') end,             desc = 'next Scope start',      mode = 'nxo' },
      { '[s', function() require('nvim-treesitter-textobjects.move').goto_previous_start('@local.scope', 'locals') end,         desc = 'prev Scope start',      mode = 'nxo' },
      -- selection
      { 'am', function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end, desc = 'select Function outer', mode = 'ox' },
      { 'im', function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end, desc = 'select Function inner', mode = 'ox' },
      { 'ac', function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end,    desc = 'select Class outer',    mode = 'ox' },
      { 'ic', function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end,    desc = 'select Class inner',    mode = 'ox' },
      { 'as', function() require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals') end,         desc = 'select Local scope',    mode = 'ox' },
    }
  }

  -- Filetype-specific keymaps (buffer-local)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'oil', 'netrw' },
    callback = function()
      require('which-key').add {
        { '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Add file', buffer = 0 },
      }
    end,
  })
end

function M:lsp_keys(_)
  local lsp = vim.lsp
  local wk  = require('which-key')

  wk.add {
    { 'K',          lsp.buf.hover,                                                        desc = 'Show Documentation' },
    { 'gO',         lazy('telescope.builtin', 'lsp_document_symbols'),                    desc = 'Show LSP Symbols' },
    { 'gy',         lazy('telescope.builtin', 'lsp_type_definitions'),                    desc = 'Go to Type Definition' },
    { 'gd',         lazy('telescope.builtin', 'lsp_definitions'),                         desc = 'Go to Definition' },
    { 'gD',         lazy('telescope.builtin', 'lsp_declarations'),                        desc = 'Go to Declaration' },
    { 'gI',         lazy('telescope.builtin', 'lsp_implementations'),                     desc = 'Go to Implementation' },
    { 'gr',         lazy('telescope.builtin', 'lsp_references'),                          desc = 'Show References' },
    { '<C-h>',      lsp.buf.signature_help,                                               desc = 'Show signature [h]elp', mode = 'i' },
    -- format, rename, code action, etc.
    { '<leader>=',  lsp.buf.format,                                                       desc = 'Format' },
    { '<leader>ca', lsp.buf.code_action,                                                  desc = 'Code Action',           mode = 'nv' },
    { '<leader>rn', lsp.buf.rename,                                                       desc = 'Rename' },
    -- diagnostics
    { '<leader>e',  function() vim.diagnostic.open_float(nil, { border = 'rounded' }) end, desc = 'Show diagnostic [e]rror inline' },
    -- workspace
    { '<leader>wa', lsp.buf.add_workspace_folder,                                         desc = '[a]dd workspace folder' },
    { '<leader>wr', lsp.buf.remove_workspace_folder,                                      desc = '[r]emove workspace folder' },
    { '<leader>wl', function() print(vim.inspect(lsp.buf.list_workspace_folders())) end,  desc = '[l]ist workspace folders' },
    { '<leader>ws', lazy('telescope.builtin', 'lsp_workspace_symbols'),                   desc = 'Show LSP Workspace Symbols' },
  }
end

function M:gitsigns_keys(_)
  local gitsigns = require('gitsigns')
  local wk       = require('which-key')

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

    -- Text object
    { 'ih',         gitsigns.select_hunk,                                                       mode = 'ox' },
  }
end

return M
