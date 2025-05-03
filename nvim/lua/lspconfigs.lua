local lspsaga = require('lspsaga')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')
local capabilities = require('blink.cmp').get_lsp_capabilities()

lspsaga.setup({
  lightbulb = {
    enable = false,
  },
  rename = {
    keys = {
      quit = '<esc>',
    },
  },
})

local on_attach = function(_, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set('n', '<S-k>', '<cmd>Lspsaga hover_doc<cr>', bufopts)
  vim.keymap.set('n', '<leader>=', vim.lsp.buf.format, bufopts)
  vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<cr>', bufopts)
  vim.keymap.set('n', '<leader>e', '<cmd>Lspsaga show_line_diagnostics<cr>', bufopts)
  vim.keymap.set('n', '<leader>gd', '<cmd>Lspsaga goto_definition<cr>', bufopts)
  vim.keymap.set('n', '<leader>gr', '<cmd>Lspsaga finder<cr>', bufopts)
  vim.keymap.set('n', '<leader>q', '<cmd>Lspsaga show_buf_diagnostics<cr>', bufopts)
  vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<cr>', bufopts)
  vim.keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<cr>', bufopts)
  vim.keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<cr>', bufopts)
end

local default_handler = function(server_name)
  lspconfig[server_name].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local handlers = {
  default_handler,

  -- ['basedpyright'] = function()
  --   lspconfig['basedpyright'].setup {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --     settings = {
  --       basedpyright = {
  --         disableOrganizeImports = true,
  --         -- typeCheckingMode = 'strict',
  --         typeCheckingMode = 'standard',
  --         -- analysis = {
  --         --   ignore = { '*' }, -- Ignore all files for analysis to exclusively use Ruff for linting
  --         -- },
  --       },
  --     },
  --   }
  -- end,

  ['pyright'] = function()
    lspconfig['pyright'].setup {
      on_attach = on_attach,
      -- capabilities = capabilities,
      settings = {
        analysis = {
          ignore = { '*' },
        },
      },
    }
  end,

  ['ruff'] = function()
    lspconfig['ruff'].setup {
      on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
      end,
      -- capabilities = capabilities,
    }
  end,

  ['docker_ls'] = nil,
  ['lua_ls'] = nil,
}

local ensure_installed = {}
for server, _ in ipairs(handlers) do
  if type(server) == "string" then
    table.insert(ensure_installed, server)
  end
end

mason.setup()
mason_lspconfig.setup({
  ensure_installed = ensure_installed,
  handlers = handlers
})
