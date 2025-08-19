return {
  -- greeter
  {
    'goolord/alpha-nvim',
    config = function()
      local startify = require('alpha.themes.startify')
      require('alpha').setup(startify.config)
    end
  },

  -- LSPs: diagnostic, auto-formatting, code actions, and more.
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig'
    },
  },
  {
    'scalameta/nvim-metals',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = { 'scala', 'sbt', 'java' },
    opts = function()
      local metals_config = require('metals').bare_config()

      metals_config.init_options.statusBarProvider = 'off'
      metals_config.capabilities = require('cmp_nvim_lsp').default_capabilities()
      metals_config.on_attach = function(client, bufnr)
        if not client then
          return
        end

        -- disable key bindings
        pcall(vim.keymap.del, 'n', 'K', { buffer = bufnr })

        -- custom key bindings
        require('keymappings').lsp_keys(bufnr)
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = self.ft,
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
  },

  -- DAP
  -- { 'mfussenegger/nvim-dap',
  --   dependencies = {
  --     'mfussenegger/nvim-dap-python',
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

  -- Git
  {
    'NeogitOrg/neogit',
    dependencies = { 'sindrets/diffview.nvim' },
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          require('keymappings').gitsigns_keys(bufnr)
        end
      }
    end
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
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.nvim',
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
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
    event = 'VeryLazy',
    config = function()
      require('marks').setup {}
    end
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    event = 'WinLeave',
    config = true,
  },

  -- Navigation
  {
    'stevearc/oil.nvim',
    dependencies = { 'benomahony/oil-git.nvim' },
    opts = {
      float = {
        max_width = 0.6,
        max_height = 0.5,
      },
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'x' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
      { 'r', mode = { 'o', 'x' }, function() require('flash').remote() end, desc = 'Remote Flash' },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Remote Flash Treesitter' },
      { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash' },
    }
  },
  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      require('smart-splits').setup {}
    end
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
    opts = {
      preset = 'helix',
      delay = function(ctx)
        return ctx.plugin and 0 or 500
      end,
    },
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    dependencies = {
      { 'junegunn/fzf', build = './install --bin' },
      { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    },
    config = function()
      require('bqf').setup {
        filter = {
          fzf = {
            extra_opts = {'--bind', 'ctrl-o:toggle-all', '--delimiter', '│'}
          }
        }
      }
    end
  },
  {
    'stevearc/quicker.nvim',
    config = function()
      require('quicker').setup {}
    end
  },

  -- Autocompletion (snippets, AI, etc.)
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
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
    }
  },
  {
    'milanglacier/minuet-ai.nvim',
    config = function()
      require('minuet').setup {
        provider = 'claude',
        provider_options = {
          claude = { model = 'claude-sonnet-4-20250514' }
        },
        cmp = { enable_auto_complete = false },
      }
    end,
  },
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = true,
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles' },
      },
      -- Diff management
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
    opts = {
      terminal = {
        split_width_percentage = 0.4,
      },
    },
  },

  -- Auto-session
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      auto_restore = false,
    },
  },
}
