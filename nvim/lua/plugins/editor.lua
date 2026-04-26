-- Editor enhancements and utilities

return {
  -- ==========================================================================
  -- UI & Interface
  -- ==========================================================================
  -- {
  --   'goolord/alpha-nvim',
  --   config = function()
  --     local startify = require('alpha.themes.startify')
  --     require('alpha').setup(startify.config)
  --   end
  -- },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'helix',
      delay = function(ctx)
        return ctx.plugin and 0 or 500
      end,
    },
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    event = 'WinLeave',
    config = true,
  },
  {
    'rachartier/tiny-cmdline.nvim',
    config = function()
      tc = require('tiny-cmdline')
      tc.setup {
        on_reposition = tc.adapters.blink,
      }
    end
  },

  -- ==========================================================================
  -- File Management
  -- ==========================================================================
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
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  -- ==========================================================================
  -- Navigation & Motion
  -- ==========================================================================
  {
    'mrjones2014/smart-splits.nvim',
    opts = {},
  },

  -- ==========================================================================
  -- Paired Characters
  -- ==========================================================================
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

  -- ==========================================================================
  -- Quickfix & Lists
  -- ==========================================================================
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    dependencies = {
      { 'junegunn/fzf',                    build = './install --bin' },
      { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    },
    opts = {
      filter = {
        fzf = {
          extra_opts = { '--bind', 'ctrl-o:toggle-all', '--delimiter', '│' }
        }
      }
    },
  },
  {
    'stevearc/quicker.nvim',
    opts = {},
  },

  -- ==========================================================================
  -- Markdown
  -- ==========================================================================
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
  },
  {
    'yousefhadder/markdown-plus.nvim',
    ft = 'markdown',
    opts = {},
    config = function(_, opts)
      require('markdown-plus').setup(opts)
      -- ]b/[b conflicts with mini.bracketed (buffer nav); move code block nav to ]`/[`
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function(ev)
          vim.schedule(function()
            pcall(vim.keymap.del, 'n', ']b', { buffer = ev.buf })
            pcall(vim.keymap.del, 'n', '[b', { buffer = ev.buf })
            vim.keymap.set('n', ']`', '<Plug>(MarkdownPlusCodeBlockNext)', { buffer = ev.buf, desc = 'Next code block' })
            vim.keymap.set('n', '[`', '<Plug>(MarkdownPlusCodeBlockPrev)', { buffer = ev.buf, desc = 'Prev code block' })
          end)
        end,
      })
    end,
  },
  -- {
  --   'obsidian-nvim/obsidian.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   ft = 'markdown',
  --   cmd = { 'Obsidian' },
  --   opts = {
  --     legacy_commands = false, -- this will be removed in the next major release
  --     workspaces = {
  --       {
  --         name = 'personal',
  --         path = '~/Documents/Obsidian',
  --       },
  --     },
  --   },
  -- },

  -- ==========================================================================
  -- Git Integration
  -- ==========================================================================
  {
    'NeogitOrg/neogit',
    lazy = true,
    cmd = 'Neogit'
  },
  {
    url = 'https://codeberg.org/trevorhauter/gitportal.nvim',
    opts = {
      git_provider_map = {
        ['git@git.parcelperform.com:'] = {
          provider = 'gitlab',
          base_url = 'https://git.parcelperform.com/',
        }
      },
    },
  },
  {
    'dlyongemallo/diffview.nvim',
    version = '*'
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

  -- ==========================================================================
  -- AI Assistants
  -- ==========================================================================
  {
    'coder/claudecode.nvim',
    -- cmd = {
    --   'ClaudeCode',
    --   'ClaudeCodeFocus',
    --   'ClaudeCodeSelectModel',
    --   'ClaudeCodeAdd',
    --   'ClaudeCodeSend',
    --   'ClaudeCodeTreeAdd',
    --   'ClaudeCodeDiffAccept',
    --   'ClaudeCodeDiffDeny',
    -- },
    config = true,
    opts = {
      terminal = {
        provider = 'none',
      },
    },
  },
}
