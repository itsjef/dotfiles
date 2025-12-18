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
    'hat0uma/csvview.nvim',
    opts = {
      parser = { comments = { '#', '//' } },
      -- view = { display_mode = 'border' },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { 'if', mode = { 'o', 'x' } },
        textobject_field_outer = { 'af', mode = { 'o', 'x' } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
        jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
        jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
        jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
      },
    },
    cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
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
}
