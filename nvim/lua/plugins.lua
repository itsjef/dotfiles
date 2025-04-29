return {
  -- common dependencies
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },

  -- greeter
  {
    'goolord/alpha-nvim',
    config = function()
      require('alpha').setup(
        require 'alpha.themes.startify'.config
      )
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
    version = 'v4.*',
  },
  {
    'nvim-lualine/lualine.nvim',
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
      'MunifTanjim/nui.nvim',
      'Kaiser-Yang/blink-cmp-avante',
    },
    version = '1.*',
    opts = require('conf.blink').setup(),
    opts_extend = { 'sources.default' }
  },

  -- Colorscheme & Syntax Highlighting
  {
    'catppuccin/nvim',
    name = 'catppuccin'
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
      'nvim-telescope/telescope-live-grep-args.nvim'
    },
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

  -- Utils & Helpers
  {
    'echasnovski/mini.nvim',
    config = require('conf.mini').setup,
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      indent = { enabled = true }
    },
    keys = {
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    }
  },

  -- AI assistants
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    opts = require('conf.avante').setup(),
    -- build = 'make',
    dependencies = {
      'stevearc/dressing.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      -- {
      --   -- support for image pasting
      --   'HakonHarnes/img-clip.nvim',
      --   event = 'VeryLazy',
      --   opts = {
      --     default = {
      --       embed_image_as_base64 = false,
      --       prompt_for_file_name = false,
      --       drag_and_drop = {
      --         insert_mode = true,
      --       },
      --     },
      --   },
      -- },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  }
}
