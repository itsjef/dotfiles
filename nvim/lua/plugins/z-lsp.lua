return {
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig'
    },
    config = function()
      local lsp = vim.lsp

      -- Extend default LSP capabilities
      local capabilities = require('blink.cmp').get_lsp_capabilities(lsp.protocol.make_client_capabilities())
      lsp.config('*', { capabilities = capabilities })

      -- Disable default key bindings
      for _, binding in ipairs({ 'grn', 'gra', 'gri', 'grr', 'grt' }) do
        pcall(vim.keymap.del, 'n', binding)
      end

      -- Create key bindings, commands, autocommands, etc. on LSP attach
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(e)
          local bufnr = e.buf
          local client = lsp.get_client_by_id(e.data.client_id)

          if not client then
            return
          end

          -- Attach navic if available
          local ok, navic = pcall(require, 'nvim-navic')
          if ok and client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
          end

          ---@diagnostic disable-next-line need-check-nil
          if client.server_capabilities.completionProvider then
            vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
          end

          ---@diagnostic disable-next-line need-check-nil
          if client.server_capabilities.definitionProvider then
            vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
          end

          -- disable key bindings
          pcall(vim.keymap.del, 'n', 'K', { buffer = bufnr })

          -- custom key bindings
          require('keymappings').lsp_keys(bufnr)
        end
      })

      -- Servers
      local ensure_installed = {
        'dockerls',
        'lua_ls',
        'marksman',
        'pyright',
        'ruff',
      }
      require('mason').setup()
      require('mason-lspconfig').setup({ ensure_installed = ensure_installed })

      lsp.config.pyright = {
        filetypes = { 'python' },
        settings = {
          python = {
            analysis = {
              ignore = { '*' },
            },
          },
        },
      }
    end,
  },
  {
    'scalameta/nvim-metals',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = { 'scala', 'sbt', 'java' },
    opts = function()
      local lsp = vim.lsp
      local metals_config = require('metals').bare_config()

      metals_config.settings = {
        superMethodLensesEnabled = true,
        showImplicitArguments = true,
        showInferredType = true,
        showImplicitConversionsAndClasses = true,
        excludedPackages = {},
        useGlobalExecutable = true, -- force using MetaLS 1.3.5 (`cs install metals:1.3.5`) in order to work with Java 11
      }
      metals_config.init_options.statusBarProvider = 'off'
      metals_config.capabilities = require('blink.cmp').get_lsp_capabilities(lsp.protocol.make_client_capabilities())
      metals_config.on_attach = function(client, bufnr)
        if not client then
          return
        end

        -- Attach navic if available
        local ok, navic = pcall(require, 'nvim-navic')
        if ok and client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end

        -- disable key bindings
        pcall(vim.keymap.del, 'n', 'K', { buffer = bufnr })

        -- custom key bindings
        require('keymappings').lsp_keys(bufnr)
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = self.ft,
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
  },
}
