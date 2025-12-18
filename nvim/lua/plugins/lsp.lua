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
          local wk = require('which-key')
          wk.add {
            { 'K', function() lsp.buf.hover({ border = 'single' }) end, desc = 'Show Documentation' },
            { 'gO', function() Snacks.picker.lsp_symbols() end, desc = 'Show LSP Symbols' },
            { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Go to Type Definition' },
            { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Go to Definition' },
            { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Go to Declaration' },
            { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Go to Implementation' },
            { 'gr', function() Snacks.picker.lsp_references() end, desc = 'Show References' },
            { '<C-h>', lsp.buf.signature_help, desc = 'Show signature [h]elp', mode = 'i' },
            -- format, rename, code action, etc.
            { '<leader>=', lsp.buf.format, desc = 'Format' },
            { '<leader>ca', lsp.buf.code_action, desc = 'Code Action', mode = 'nv' },
            { '<leader>rn', lsp.buf.rename, desc = 'Rename' },
            -- diagnostics
            { '<leader>e', function() vim.diagnostic.open_float(nil, { border = 'rounded' }) end, desc = 'Show diagnostic [e]rror inline' },
            -- workspace
            { '<leader>wa', lsp.buf.add_workspace_folder, desc = '[a]dd workspace folder' },
            { '<leader>wr', lsp.buf.remove_workspace_folder, desc = '[r]emove workspace folder' },
            { '<leader>wl', function() print(vim.inspect(lsp.buf.list_workspace_folders())) end, desc = '[l]ist workspace folders' },
            { '<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'Show LSP Workspace Symbols' },
          }
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

      metals_config.settings = { javaHome = '/opt/homebrew/Cellar/openjdk@11/11.0.29' }
      metals_config.init_options.statusBarProvider = 'off'
      metals_config.capabilities = require('blink.cmp').get_lsp_capabilities(lsp.protocol.make_client_capabilities())
      metals_config.on_attach = function(client, bufnr)
        if not client then
          return
        end

        -- disable key bindings
        pcall(vim.keymap.del, 'n', 'K', { buffer = bufnr })

        -- custom key bindings
        local wk = require('which-key')
        wk.add {
          { 'K', function() lsp.buf.hover({ border = 'single' }) end, desc = 'Show Documentation' },
          { 'gO', function() Snacks.picker.lsp_symbols() end, desc = 'Show LSP Symbols' },
          { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Go to Type Definition' },
          { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Go to Definition' },
          { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Go to Declaration' },
          { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Go to Implementation' },
          { 'gr', function() Snacks.picker.lsp_references() end, desc = 'Show References' },
          { '<C-h>', lsp.buf.signature_help, desc = 'Show signature [h]elp', mode = 'i' },
          -- format, rename, code action, etc.
          { '<leader>=', lsp.buf.format, desc = 'Format' },
          { '<leader>ca', lsp.buf.code_action, desc = 'Code Action', mode = 'nv' },
          { '<leader>rn', lsp.buf.rename, desc = 'Rename' },
          -- diagnostics
          { '<leader>e', function() vim.diagnostic.open_float(nil, { border = 'rounded' }) end, desc = 'Show diagnostic [e]rror inline' },
          -- workspace
          { '<leader>wa', lsp.buf.add_workspace_folder, desc = '[a]dd workspace folder' },
          { '<leader>wr', lsp.buf.remove_workspace_folder, desc = '[r]emove workspace folder' },
          { '<leader>wl', function() print(vim.inspect(lsp.buf.list_workspace_folders())) end, desc = '[l]ist workspace folders' },
          { '<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'Show LSP Workspace Symbols' },
        }
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
