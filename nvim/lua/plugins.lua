return {
  -- greeter
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local startify = require('alpha.themes.startify')
      startify.file_icons.provider = 'devicons'
      require('alpha').setup(startify.config)
    end
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
      'HiPhish/rainbow-delimiters.nvim',
    },
    config = require('conf.treesitter').setup
  },

  -- LSPs: diagnostic, auto-formatting, code actions, and more.
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig'
    },
  },

  -- DAP
  -- { 'mfussenegger/nvim-dap',
  --   dependencies = {
  --     'mfussenegger/nvim-dap-python',
  --     'nvim-telescope/telescope-dap.nvim',
  --     'rcarriga/nvim-dap-ui',
  --     'theHamsta/nvim-dap-virtual-text',
  --   },
  -- },

  -- File explorer, Bufferline, Statusline
  {
    'nvim-tree/nvim-tree.lua',
    version = 'v1.*',
    keys = {
      { '<leader>nn', '<cmd>NvimTreeToggle<CR>', desc = 'NvimTree' },
    },
    config = function()
      require('nvim-tree').setup {
        view = {
          side = 'right',
        },
        renderer = {
          highlight_git = true,
        }
      }
    end
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    version = 'v4.*',
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require('conf.lualine').setup,
  },

  -- Git
  'tpope/vim-fugitive',

  -- Autocompletion & snippets
  {
    'saghen/blink.cmp',
    dependencies = {
      'saghen/blink.compat',
      'onsails/lspkind.nvim',
      'nvim-tree/nvim-web-devicons',
      'rafamadriz/friendly-snippets',
      'folke/noice.nvim',
    },
    version = '1.*',
    opts = require('conf.blink').setup(),
    opts_extend = { 'sources.default' }
  },

  -- Colorscheme & Syntax Highlighting
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
  },
  {
    'projekt0n/github-nvim-theme',
    version = '*',
  },
  {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup()
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    event = { 'WinLeave' },
    config = function()
      require('colorful-winsep').setup({
        no_exec_files = {
          -- 'NvimTree',
          'TelescopePrompt',
          'alpha',
          'lazy',
          'mason',
        },
        only_line_seq = false,
      })
    end,
  },

  -- Navigation
  {
    'smoka7/hop.nvim',
    version = 'v2.*',
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-frecency.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
  },

  -- Utils & Helpers
  {
    'echasnovski/mini.nvim',
    config = require('conf.mini').setup,
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      indent = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      words = { enabled = true },
      input = { enabled = true },
      -- dashboard = { enabled = true },
      -- explorer = { enabled = true },
      -- scroll = { enabled = true },
      -- statuscolumn = { enabled = true },
      -- styles = {
      --   notification = {
      --     -- wo = { wrap = true } -- Wrap notifications
      --   }
      -- }
    },
    keys = {
      -- -- Top Pickers & Explorer
      -- { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
      -- { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      -- { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep' },
      -- { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History' },
      -- { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History' },
      -- { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },
      -- -- find
      -- { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      -- { '<leader>fc', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, desc = 'Find Config File' },
      -- { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' },
      -- { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
      -- { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },
      -- { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },
      -- -- git
      -- { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
      -- { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
      -- { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
      -- { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
      -- { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },
      -- { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
      -- { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File' },
      -- -- Grep
      -- { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
      -- { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
      -- { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep' },
      -- { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' } },
      -- -- search
      -- { '<leader>s'', function() Snacks.picker.registers() end, desc = 'Registers' },
      -- { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
      -- { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
      -- { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
      -- { '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History' },
      -- { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands' },
      -- { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
      -- { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
      -- { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages' },
      -- { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights' },
      -- { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons' },
      -- { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
      -- { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
      -- { '<leader>sl', function() Snacks.picker.loclist() end, desc = 'Location List' },
      -- { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },
      -- { '<leader>sM', function() Snacks.picker.man() end, desc = 'Man Pages' },
      -- { '<leader>sp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec' },
      -- { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
      -- { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Resume' },
      -- { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History' },
      -- { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
      -- LSP
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
      { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Goto Declaration' },
      { 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
      { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' },
      { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' },
      { '<leader>ss', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },
      { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },
      -- Other
      -- { '<leader>z',  function() Snacks.zen() end, desc = 'Toggle Zen Mode' },
      -- { '<leader>Z',  function() Snacks.zen.zoom() end, desc = 'Toggle Zoom' },
      -- { '<leader>.',  function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
      -- { '<leader>S',  function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
      -- { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File' },
      -- { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse', mode = { 'n', 'v' } },
      -- { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
      -- { '<c-/>',      function() Snacks.terminal() end, desc = 'Toggle Terminal' },
      -- { '<c-_>',      function() Snacks.terminal() end, desc = 'which_key_ignore' },
      { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
      { '<leader>n',  function() Snacks.notifier.show_history() end, desc = 'Notification History' },
      { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications' },
      -- { ']]',         function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
      -- { '[[',         function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },
    },
  },

  -- AI assistants
  {
    'olimorris/codecompanion.nvim',
    opts = {},
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('codecompanion').setup({
        strategies = {
          chat = {
            adapter = 'anthropic',
          },
          inline = {
            adapter = 'anthropic',
          },
        },
      })
    end
  },
}
