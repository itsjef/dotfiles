-- alpha-nvim
local startify = require('alpha.themes.startify')
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
    'regex',
    'toml',
    'vimdoc',
    'yaml',
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
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
    lualine_x = { 'encoding', 'fileformat', 'filetype', { require('codecompanion_lualine') } },
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


-- statuscol.nvim
require('statuscol').setup {}


-- blink.cmp
require('blink.cmp').setup {
  enabled = function()
    local disabled_fts = { 'lua', 'markdown' }
    return not vim.tbl_contains(disabled_fts, vim.bo.filetype)
  end,
  cmdline = { enabled = true },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      codecompanion = {
        name = 'CodeCompanion',
        module = 'codecompanion.providers.completion.blink',
        enabled = true,
      },
    },
    per_filetype = {
      codecompanion = { 'codecompanion', 'path' },
    },
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
              local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
              return kind_icon
            end,
            -- (optional) use highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
              return hl
            end,
          },
          kind = {
            -- (optional) use highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
              return hl
            end,
          },
        },
        columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon' }, { 'kind' } },
        treesitter = { 'lsp' },
      }
    }
  },
}


-- marks.nvim
require('marks').setup()


-- gitsigns.nvim
require('gitsigns').setup {
  on_attach = function(bufnr)
    require('keymappings').gitsigns_keys(bufnr)
  end
}


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
local mini_modules = {
  'ai',
  'align',
  'bracketed',
  'files',
  'icons',
  'pairs',
  'splitjoin',
  'surround',
  'trailspace',
}

for _, module in ipairs(mini_modules) do
  require('mini.' .. module).setup()
end

local formatAugroup = vim.api.nvim_create_augroup('FormatAutogroup', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  group = formatAugroup,
  callback = function()
    MiniTrailspace.trim()
    MiniTrailspace.trim_last_lines()
  end,
})

MiniIcons.mock_nvim_web_devicons()


-- telescope.nvim
local telescope = require('telescope')
local actions = require('telescope.actions')
local lga_actions = require('telescope-live-grep-args.actions')

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<ESC>'] = actions.close,
        ['<CR>'] = actions.select_default + actions.center,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
        ['<Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_worse,
      },
      n = {
        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
        ['<Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_worse,
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
          ['<C-t>'] = lga_actions.quote_prompt({ postfix = ' -t'}),
          ['<C-space>'] = lga_actions.to_fuzzy_refine,
        },
      },
    },
    frecency = {
      hide_current_buffer = true,
    },
    ['ui-select'] = {
      require('telescope.themes').get_dropdown {}
    },
  },
}
telescope.load_extension('frecency')
telescope.load_extension('fzf')
telescope.load_extension('live_grep_args')
telescope.load_extension('ui-select')


-- codecompanion.nvim
require('codecompanion').setup {
  adapters = {
    anthropic = function()
      return require('codecompanion.adapters').extend('anthropic', {
        schema = {
          model = {
            default = 'claude-opus-4-20250514',
          },
          temperature = {
            default = 0.8
          },
        },
      })
    end,
  },
  strategies = {
    chat = { adapter = 'anthropic' },
    inline = { adapter = 'anthropic' },
  },
}


-- snacks.nvim
require('snacks').setup {
  bigfile = { enabled = true },
  gitbrowse = {
    url_patterns = {
      ["git%.parcelperform%.com"] = {
        branch = "/-/tree/{branch}",
        file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
        permalink = "/-/blob/{commit}/{file}#L{line_start}-L{line_end}",
        commit = "/-/commit/{commit}",
      },
    }
  },
  indent = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  words = { enabled = true },
}


-- noice.nvim
require('noice').setup {
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
    },
  },
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    long_message_to_split = true, -- long messages will be sent to a split
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
}


-- nvim-bqf
require('bqf').setup {
  filter = {
    fzf = {
      extra_opts = {'--bind', 'ctrl-o:toggle-all', '--delimiter', '│'}
    }
  }
}


-- which-key
require('which-key').setup {
  preset = 'helix',
  delay = function(ctx)
    return ctx.plugin and 0 or 500
  end,
}
