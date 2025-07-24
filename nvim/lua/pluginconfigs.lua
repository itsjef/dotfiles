-- Plugin: alpha-nvim
local startify = require('alpha.themes.startify')
require('alpha').setup(startify.config)


-- Plugin: treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = {
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
    'toml',
    'typst',
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


-- Plugin: lualine
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
    lualine_x = { 'copilot', 'encoding', 'fileformat', 'filetype' },
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


-- Plugin: statuscol.nvim
require('statuscol').setup {}


-- Plugin: marks.nvim
require('marks').setup()


-- Plugin: gitsigns.nvim
require('gitsigns').setup {
  on_attach = function(bufnr)
    require('keymappings').gitsigns_keys(bufnr)
  end
}


-- Plugin: colorful-winsep.nvim
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


-- Plugin: hop.nvim
require('hop').setup {}


-- Plugin: mini.nvim
local mini_modules = {
  'ai',
  'align',
  'animate',
  'bracketed',
  'files',
  'icons',
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


-- Plugin: telescope.nvim
local telescope = require('telescope')
local actions = require('telescope.actions')
local lga_actions = require('telescope-live-grep-args.actions')
local open_with_trouble = require('trouble.sources.telescope').open

-- Use this to add more results without clearing the trouble list
-- local add_to_trouble = require('trouble.sources.telescope').add

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<ESC>'] = actions.close,
        ['<CR>'] = actions.select_default + actions.center,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
        ['<C-t>'] = open_with_trouble,
        ['<Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_worse,
      },
      n = {
        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
        ['<C-t>'] = open_with_trouble,
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


-- Plugin: snacks.nvim
require('snacks').setup {
  bigfile = { enabled = true },
  gitbrowse = {
    url_patterns = {
      ['git%.parcelperform%.com'] = {
        branch = '/-/tree/{branch}',
        file = '/-/blob/{branch}/{file}#L{line_start}-L{line_end}',
        permalink = '/-/blob/{commit}/{file}#L{line_start}-L{line_end}',
        commit = '/-/commit/{commit}',
      },
    }
  },
  indent = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  words = { enabled = true },
}


-- Plugin: nvim-bqf
require('bqf').setup {
  filter = {
    fzf = {
      extra_opts = {'--bind', 'ctrl-o:toggle-all', '--delimiter', '│'}
    }
  }
}


-- Plugin: which-key
require('which-key').setup {
  preset = 'helix',
  delay = function(ctx)
    return ctx.plugin and 0 or 500
  end,
}


-- Plugin: smart-splits
require('smart-splits').setup {}


-- Plugin: autocompletion
require('copilot').setup {
  suggestion = { enabled = false },
  panel = { enabled = false },
  filetypes = {
    markdown = true,
    help = true,
  },
}

require('copilot_cmp').setup()

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  completion = {
    completeopt = 'menu,menuone,noselect',
  },
  preselect = cmp.PreselectMode.None,
  sorting = {
    priority_weight = 1.0,
    comparators = {
      cmp.config.compare.locality,
      cmp.config.compare.recently_used,
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.order,
    },
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if luasnip.expandable() then
          luasnip.expand()
        else
          cmp.confirm({ select = true })
        end
      else
          fallback()
      end
    end),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
  }),
  sources = cmp.config.sources({
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp_document_symbol' },
    { name = 'luasnip' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
  }),
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline', option = { treat_trailing_slash = false } }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Add parentheses after selecting function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

-- Use existing VS Code style snippets from plugin (rafamadriz/friendly-snippets)
require('luasnip.loaders.from_vscode').lazy_load()
