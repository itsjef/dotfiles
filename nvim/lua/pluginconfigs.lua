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


-- blink.cmp
require('blink.cmp').setup {
  enabled = function()
    local disabled_fts = { 'lua', 'markdown' }
    return not vim.tbl_contains(disabled_fts, vim.bo.filetype)
  end,
  cmdline = { enabled = true },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
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
local gitsigns = require('gitsigns')

gitsigns.setup {
  on_attach = function(bufnr)

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']h', function()
      if vim.wo.diff then
        vim.cmd.normal({']h', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end, { desc = 'Hunk forward' })

    map('n', '[h', function()
      if vim.wo.diff then
        vim.cmd.normal({'[h', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end, { desc = 'Hunk backward' })

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage Hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset Hunk' })

    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'Stage Hunk (selection)' })

    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'Reset Hunk (selection)' })

    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage Buffer' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset Buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview Hunk' })
    map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'Preview Hunk (inline)' })
    map('n', '<leader>hb', function() gitsigns.blame_line({ full = true }) end, { desc = 'Git blame (current line)' })
    -- map('n', '<leader>hd', gitsigns.diffthis)
    -- map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
    -- map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
    -- map('n', '<leader>hq', gitsigns.setqflist)
    map('n', '<leader>tB', gitsigns.toggle_current_line_blame, { desc = 'Toggle git blame (inline)' })
    map('n', '<leader>tW', gitsigns.toggle_word_diff, { desc = 'Toggle word diff' })

    -- Text object
    map({'o', 'x'}, 'ih', gitsigns.select_hunk)
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
  'bufremove',
  'files',
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
          ['<C-t>'] = lga_actions.quote_prompt({ postfix = ' -t'}),
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
require('noice').setup {}


-- nvim-bqf
require('bqf').setup {
  filter = {
    fzf = {
      extra_opts = {'--bind', 'ctrl-o:toggle-all', '--delimiter', '│'}
    }
  }
}
