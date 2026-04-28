return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      -- Defer parser install/check until after UI is up so it doesn't block startup.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        once = true,
        callback = function()
          require('nvim-treesitter').install {
            'bash',
            'comment',
            'dockerfile',
            'html',
            'http',
            'latex',
            'lua',
            'make',
            'markdown',
            'markdown_inline',
            'python',
            'regex',
            'scala',
            'toml',
            'typst',
            'vimdoc',
            'yaml',
          }
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('treesitter-context').setup {
        multiline_threshold = 1,
        trim_scope = 'inner'
      }
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        set_jumps = true,
      }
    end
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('rainbow-delimiters.setup').setup {}
    end
  },
}
