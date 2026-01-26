return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
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
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
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
    config = function()
      require('nvim-treesitter-textobjects').setup {
        set_jumps = true,
      }
    end
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
      require('rainbow-delimiters.setup').setup {}
    end
  },
}
