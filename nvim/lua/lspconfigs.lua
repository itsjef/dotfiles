local lsp = vim.lsp


-- Extend default LSP capabilities and extend them with blink.cmp's
local capabilities = require('blink.cmp').get_lsp_capabilities(lsp.protocol.make_client_capabilities())
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

    -- Key mappings
    local set_keymap = vim.keymap.set
    local opts = { silent = true, noremap = true, buffer = bufnr }
    local opt = function(desc)
      return vim.tbl_extend('force', opts, { desc = desc })
    end

    -- disable key bindings
    pcall(vim.keymap.del, 'n', 'K', { buffer = bufnr })

    -- custom key bindings
    set_keymap('n', '<leader>=', lsp.buf.format, opts)
    set_keymap('n', '<leader>ca', lsp.buf.code_action, opt('Code Action'))
    set_keymap('n', '<leader>rn', lsp.buf.rename, opt('Rename'))
    -- set_keymap('n', '<leader>wa', lsp.buf.add_workspace_folder, opt('Add Workspace Folder'))
    -- set_keymap('n', '<leader>wl', function() print(vim.inspect(lsp.buf.list_workspace_folders)) end, opt('Show Workspace Folders'))
    -- set_keymap('n', '<leader>wr', lsp.buf.remove_workspace_folder, opt('Remove Workspace Folder'))
    -- set_keymap('n', '<leader>wS', lsp.buf.workspace_symbol, opt('Show Workspace Symbol'))
    set_keymap('n', 'K', lsp.buf.hover, opt('Show Documentation'))
    set_keymap('n', 'gD', lsp.buf.declaration, opt('Go to Declaration'))
    set_keymap('n', 'gK', lsp.buf.signature_help, opt('Signature Help'))
    set_keymap('n', 'gO', lsp.buf.document_symbol, opt('Show Document Symbols'))
    set_keymap('n', 'gd', lsp.buf.definition, opt('Go to Definition'))
    set_keymap('n', 'gi', lsp.buf.implementation, opt('Go to Implementation'))
    set_keymap('n', 'gr', lsp.buf.references, opt('Show References'))
    set_keymap('n', 'gy', lsp.buf.type_definition, opt('Go to Type Definition'))
    set_keymap('n', '[d', vim.diagnostic.goto_prev, opts)
    set_keymap('n', ']d', vim.diagnostic.goto_next, opts)
    set_keymap('n', '<leader>e', vim.diagnostic.open_float, opts)
    set_keymap('n', '<leader>q', vim.diagnostic.setqflist, opts)
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
