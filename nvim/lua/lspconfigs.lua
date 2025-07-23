local lsp = vim.lsp


-- Extend default LSP capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lsp.config('*', { capabilities = capabilities })


-- Disable default key bindings
for _, binding in ipairs({ 'grn', 'gra', 'gri', 'grr' }) do
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
    require('keymappings').lsp_keys(bufnr)
  end
})


-- Servers
local ensure_installed = { 'pyright', 'ruff', 'dockerls', 'lua_ls' }
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
