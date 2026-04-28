return {
  'nvim-mini/mini.nvim',
  lazy = false,
  priority = 900,
  config = function()
    -- Eagerly set up icons since lualine/blink/oil read them at startup.
    require('mini.icons').setup()
    MiniIcons.mock_nvim_web_devicons()

    -- Defer the rest of mini's modules until after startup.
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      once = true,
      callback = function()
        local mini_modules = {
          'ai',
          'align',
          'bracketed',
          'bufremove',
          'cursorword',
          'indentscope',
          'jump',
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
            if MiniTrailspace then
              MiniTrailspace.trim()
              MiniTrailspace.trim_last_lines()
            end
          end,
        })
      end,
    })
  end,
}
