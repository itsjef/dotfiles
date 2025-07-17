return {
  -- greeter
  {
    'goolord/alpha-nvim',
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

  -- File explorer, Bufferline, Statusline, Statuscolumn
  {
    'akinsho/bufferline.nvim',
    version = 'v4.*',
  },
  {
    'nvim-lualine/lualine.nvim',
  },
  {
    'luukvbaal/statuscol.nvim',
  },

  -- Git
  {
    'NeogitOrg/neogit',
    dependencies = { 'sindrets/diffview.nvim' },
  },
  {
    'lewis6991/gitsigns.nvim',
  },

  -- Colorscheme & Syntax Highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
      'HiPhish/rainbow-delimiters.nvim',
      'OXY2DEV/markview.nvim',
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
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
  },
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = 'Trouble'
  },
  {
    'mrjones2014/smart-splits.nvim',
  },

  -- Utils & Helpers
  {
    'echasnovski/mini.nvim',
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
  },
  {
    'folke/which-key.nvim',
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
    dependencies = {
      { 'junegunn/fzf', build = './install --bin' },
      { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    },
  },

  -- Autocompletion (snippets, AI, etc.)
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    dependencies = {
      'AndreM222/copilot-lualine',
    },
  },
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    dependencies = {
     'rafamadriz/friendly-snippets',
    }
  },
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
      'zbirenbaum/copilot-cmp',
    }
  },
}
