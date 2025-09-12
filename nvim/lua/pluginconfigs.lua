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
  multiline_threshold = 1,
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
    lualine_x = { { require('minuet.lualine') }, 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress', 'location' },
    lualine_z = { {'datetime', style = '%H:%M'} }
  },
  inactive_sections = {},
  tabline = {},
  extensions = {}
}


-- Plugin: mini.nvim
local mini_modules = {
  'ai',
  'align',
  { 'animate', { cursor = { enable = false } } },
  'bracketed',
  'icons',
  'splitjoin',
  'surround',
  'trailspace',
}

for _, module in ipairs(mini_modules) do
  if type(module) == 'table' then
    require('mini.' .. module[1]).setup(module[2])
  else
    require('mini.' .. module).setup()
  end
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


-- Plugin: snacks.nvim
require('snacks').setup {
  bigfile = { enabled = true },
  explorer = { enabled = true },
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
  input = { enabled = true },
  notifier = { enabled = true },
  picker = {
    sources = {
      explorer = {
        layout = { layout = { position = 'right' } }
      },
    },
    win = {
      input = {
        keys = {
          ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
        },
      },
    },
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
}


-- Plugin: autocompletion
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
  performance = {
    fetching_timeout = 2000,
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
    ['<C-y>'] = require('minuet').make_cmp_map(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'luasnip', keyword_length = 2 },
    { name = 'path' },
    { name = 'buffer', keyword_length = 3 },
  -- }, {
  --   { name = 'minuet' },
  }),
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  completion = { autocomplete = false },
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
