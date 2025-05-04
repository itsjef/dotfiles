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

local default_handler = function(server_name)
  lspconfig[server_name].setup {
    capabilities = capabilities,
  }
end

local handlers = {
  default_handler,

  -- ['basedpyright'] = function()
  --   lspconfig['basedpyright'].setup {
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
      capabilities = capabilities,
      settings = {
        analysis = {
          ignore = { '*' },
        },
      },
    }
  end,

  ['ruff'] = function()
    lspconfig['ruff'].setup {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
      end,
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
