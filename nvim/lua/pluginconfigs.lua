-- alpha-nvim
local startify = require('alpha.themes.startify')
startify.file_icons.provider = 'devicons'
require('alpha').setup(startify.config)


-- treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'comment',
    'dockerfile',
    'http',
    'lua',
    'make',
    'markdown',
    'python',
    'toml',
    'vimdoc',
    'yaml',
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
  incremental_selection = {
    enable = false,
  },
  rainbow = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
      },
    },
    -- swap = {
    --   enable = true,
    --   swap_next = {
    --     ['<leader>a'] = '@parameter.inner',
    --   },
    --   swap_previous = {
    --     ['<leader>A'] = '@parameter.inner',
    --   },
    -- },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}
require('treesitter-context').setup {
  max_lines = 7,
  trim_scope = 'inner'
}


-- nvim-tree
require('nvim-tree').setup {
  view = {
    side = 'right',
  },
  renderer = {
    highlight_git = true,
  }
}


-- lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {},
    globalstatus = true,  -- overrides vim.o.laststatus
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}


-- blink.cmp
require('blink.cmp').setup {
  enabled = function()
    local disabled_fts = { 'lua', 'markdown' }
    return not vim.tbl_contains(disabled_fts, vim.bo.filetype)
  end,
  cmdline = { enabled = false },
  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },
  keymap = {
    preset = 'default',
    -- on Macbook, uncheck 'Switch Input Sources' shortcuts for <C-Space> to work
    ['<Tab>'] = { 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
    ['<C-j>'] = { 'select_and_accept' },  -- less finger stretch
  },
  completion = {
    -- Show documentation when selecting a completion item
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
      window = { border = 'single' },
    },

    -- Display a preview of the selected item on the current line
    ghost_text = { enabled = true },

    menu = {
      border = 'single',
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              local lspkind = require('lspkind')
              local icon = ctx.kind_icon
              if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                  local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                  if dev_icon then
                      icon = dev_icon
                  end
              else
                  icon = lspkind.symbolic(ctx.kind, {
                      mode = 'symbol',
                  })
              end

              return icon .. ctx.icon_gap
            end,

            -- Optionally, use the highlight groups from nvim-web-devicons
            -- You can also add the same function for `kind.highlight` if you want to
            -- keep the highlight groups in sync with the icons.
            highlight = function(ctx)
              local hl = ctx.kind_hl
              if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                if dev_icon then
                  hl = dev_hl
                end
              end
              return hl
            end,
          }
        }
      }
    }
  },
}


-- marks.nvim
require('marks').setup()


-- gitsigns.nvim
require('gitsigns').setup()


-- colorful-winsep.nvim
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


-- hop.nvim
require('hop').setup {}


-- mini.nvim
require('mini.ai').setup()
require('mini.bracketed').setup({
  buffer     = { suffix = 'b', options = {} },
  comment    = { suffix = 'c', options = {} },
  conflict   = { suffix = 'x', options = {} },
  -- diagnostic = { suffix = 'd', options = {} },  -- default in Neovim 0.10
  file       = { suffix = 'f', options = {} },
  indent     = { suffix = 'i', options = {} },
  jump       = { suffix = 'j', options = {} },
  location   = { suffix = 'l', options = {} },
  oldfile    = { suffix = 'o', options = {} },
  quickfix   = { suffix = 'q', options = {} },
  treesitter = { suffix = 't', options = {} },
  undo       = { suffix = 'u', options = {} },
  window     = { suffix = 'w', options = {} },
  yank       = { suffix = 'y', options = {} },
})
require('mini.bufremove').setup()
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.trailspace').setup()

local formatAugroup = vim.api.nvim_create_augroup('FormatAutogroup', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  group = formatAugroup,
  callback = function()
    MiniTrailspace.trim()
    MiniTrailspace.trim_last_lines()
  end,
})


-- telescope.nvim
local telescope = require('telescope')
local actions = require('telescope.actions')
local lga_actions = require('telescope-live-grep-args.actions')

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<esc>'] = actions.close,
        ['<CR>'] = actions.select_default + actions.center
      },
      n = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      }
    },
    file_ignore_patterns = { 'temp%_dir/.*' },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ['<C-e>'] = lga_actions.quote_prompt(),
          ['<C-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob '}),
          ['<C-space>'] = lga_actions.to_fuzzy_refine,
        },
      },
    },
    frecency = {
      hide_current_buffer = true,
    },
  },
}
telescope.load_extension('frecency')
telescope.load_extension('fzf')
telescope.load_extension('live_grep_args')


-- gp.nvim
require('gp').setup {
  providers = {
    anthropic = {
      disable = false,
    },
    openai = {
      disable = true,
    }
  },
  default_chat_agent = 'ChatClaude-3-7-Sonnet',
}


-- snacks.nvim
require('snacks').setup {
  bigfile = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  -- picker = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  words = { enabled = true },
}
