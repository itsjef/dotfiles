return {
  -- greeter
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
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
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    version = 'v4.*',
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- Git
  {
    'sindrets/diffview.nvim',
  },
  {
    'lewis6991/gitsigns.nvim',
  },

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
    opts_extend = { 'sources.default' }
  },

  -- Colorscheme & Syntax Highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
      'HiPhish/rainbow-delimiters.nvim',
    },
  },
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
    event = { 'VeryLazy' },
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    event = { 'WinLeave' },
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
  },
  {
    'robitx/gp.nvim',
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
  },
  {
    'folke/which-key.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
