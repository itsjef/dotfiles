return {
  {
    'goolord/alpha-nvim',
    config = function()
      local startify = require('alpha.themes.startify')
      require('alpha').setup(startify.config)
    end
  },
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
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
  },
  {
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    event = 'WinLeave',
    config = true,
  },
  {
    'stevearc/oil.nvim',
    dependencies = { 'benomahony/oil-git.nvim' },
    opts = {
      float = {
        border = 'single',
        max_width = 0.6,
        max_height = 0.5,
      },
      keymaps = {
        ['q'] = { 'actions.close', mode = 'n' },
      },
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      modes = {
        keys = { 'f', 'F', 't', 'T' },
      }
    },
  },
  {
    'mrjones2014/smart-splits.nvim',
    opts = {},
  },
  {
    'andymass/vim-matchup',
    opts = {
      treesitter = {
        stopline = 500,
      }
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    dependencies = {
      { 'junegunn/fzf', build = './install --bin' },
      { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    },
    opts = {
      filter = {
        fzf = {
          extra_opts = {'--bind', 'ctrl-o:toggle-all', '--delimiter', '│'}
        }
      }
    },
  },
  {
    'stevearc/quicker.nvim',
    opts = {},
  },
  {
    'yousefhadder/markdown-plus.nvim',
    ft = 'markdown',
    opts = {},
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      auto_restore = false,
      bypass_save_filetypes = { 'alpha', 'colorful-winsep' },
      close_filetypes_on_save = { 'checkhealth', 'colorful-winsep' },
    },
  },
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    cmd = {
      'ClaudeCode',
      'ClaudeCodeFocus',
      'ClaudeCodeSelectModel',
      'ClaudeCodeAdd',
      'ClaudeCodeSend',
      'ClaudeCodeTreeAdd',
      'ClaudeCodeDiffAccept',
      'ClaudeCodeDiffDeny',
    },
    config = true,
    opts = {
      terminal = {
        split_width_percentage = 0.4,
      },
    },
  },
}
