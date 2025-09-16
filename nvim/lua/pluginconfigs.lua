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
    globalstatus = true, -- overrides vim.o.laststatus
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { { require('minuet.lualine') }, 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress', 'location' },
    lualine_z = { { 'datetime', style = '%H:%M' } }
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
require('blink.cmp').setup {
  -- enabled = function()
  --   local disabled_fts = { 'lua', 'markdown' }
  --   return not vim.tbl_contains(disabled_fts, vim.bo.filetype)
  -- end,
  signature = {
    enabled = true,
    window = { border = 'single' }
  },
  cmdline = {
    enabled = true,
    completion = {
      list = { selection = { preselect = false, auto_insert = true } },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' }, -- 'minuet' excluded from default, for manual completion only
    providers = {
      minuet = {
        name = 'minuet',
        module = 'minuet.blink',
        async = true,
        -- Should match minuet.config.request_timeout * 1000,
        -- since minuet.config.request_timeout is in seconds
        timeout_ms = 3000,
        score_offset = 50, -- Gives minuet higher priority among suggestions
      },
    },
    per_filetype = {},
  },
  keymap = {
    preset = 'cmdline',
    ['<C-j>'] = { 'select_and_accept' }, -- less finger stretch
    ['<C-y>'] = require('minuet').make_blink_map(),
  },
  completion = {
    list = { selection = { preselect = false, auto_insert = true } },
    documentation = { auto_show = true, window = { border = 'single' } },
    trigger = { prefetch_on_insert = false }, -- Avoid unnecessary request
    menu = {
      auto_show = false,
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
      },
    },
  },
}
