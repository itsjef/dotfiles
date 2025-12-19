return {
  'nvim-mini/mini.nvim',
  config = function()
    local mini_modules = {
      'ai',
      'align',
      { 'animate', { cursor = { enable = false } } },
      'bracketed',
      'icons',
      'jump',
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
  end,
}
