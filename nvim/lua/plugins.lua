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
    config = function()
      require('bufferline').setup()
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    config = require('conf.lualine').setup,
  },

  -- Git
  'tpope/vim-fugitive',

  -- Autocompletion & snippets
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim',
    },
  },
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_vscode').load()
    end
  },
  -- {
  --   'zbirenbaum/copilot-cmp',
  --   dependencies = { 'zbirenbaum/copilot.lua' },
  --   config = function ()
  --     require('copilot').setup({
  --       suggestion = { enabled = false },
  --       panel = { enabled = false },
  --     })
  --     require('copilot_cmp').setup()
  --   end
  -- },

  -- Colorscheme & Syntax Highlighting
  {
    'catppuccin/nvim',
    name = 'catppuccin'
  },
  'ful1e5/onedark.nvim',
  'marko-cerovac/material.nvim',
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
    'lukas-reineke/indent-blankline.nvim',
    version = 'v3.*',
    main = 'ibl',
    opts = {},
    config = function()
      require('ibl').setup({
        scope = { enabled = false },
      })
    end
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
  -- {
  --   'mistweaverco/kulala.nvim',
  --   version = 'v3.*',
  --   config = function()
  --     require('kulala').setup({})
  --   end
  -- },

  -- AI assistants
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    opts = {
      -- provider = 'openai',
      -- openai = {
      --   endpoint = 'https://api.openai.com/v1',
      --   model = 'gpt-4o', -- your desired model (or use gpt-4o, etc.)
      --   timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
      --   temperature = 0,
      --   max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
      --   --reasoning_effort = 'medium', -- low|medium|high, only used for reasoning models
      -- },
      provider = 'claude',
      claude = {
        endpoint = 'https://api.anthropic.com',
        -- model = 'claude-3-5-sonnet-20241022',
        model = 'claude-3-7-sonnet-20250219',
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
        disable_tools = true, -- disable tools!
      },
      behaviour = {
        enable_claude_text_editor_tool_mode = true,
      }
    },
    build = 'make',
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
      -- {
      --   'MeanderingProgrammer/render-markdown.nvim',
      --   opts = {
      --     file_types = { 'markdown', 'Avante' },
      --   },
      --   ft = { 'markdown', 'Avante' },
      -- },
    },
  }
}
