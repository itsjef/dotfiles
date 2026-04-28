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

        local mc = require('mini.clue')
        mc.setup({
          triggers = {
            { mode = 'n',       keys = '<Leader>' },
            { mode = 'v',       keys = '<Leader>' },
            { mode = 'n',       keys = 'g' },
            { mode = 'x',       keys = 'g' },
            { mode = 'n',       keys = ']' },
            { mode = 'x',       keys = ']' },
            { mode = 'o',       keys = ']' },
            { mode = 'n',       keys = '[' },
            { mode = 'x',       keys = '[' },
            { mode = 'o',       keys = '[' },
            { mode = 'o',       keys = 'a' },
            { mode = 'x',       keys = 'a' },
            { mode = 'o',       keys = 'i' },
            { mode = 'x',       keys = 'i' },
          },
          clues = {
            { mode = 'n', keys = '<Leader>a', desc = '+AI/Claude Code' },
            { mode = 'n', keys = '<Leader>f', desc = '+Telescope' },
            { mode = 'n', keys = '<Leader>g', desc = '+Neogit' },
            { mode = 'n', keys = '<Leader>h', desc = '+Gitsigns' },
            { mode = 'n', keys = '<Leader>m', desc = '+Markdown' },
            mc.gen_clues.g(),
            mc.gen_clues.z(),
            mc.gen_clues.windows(),
            mc.gen_clues.marks(),
            mc.gen_clues.registers(),
          },
          window = {
            delay = 500,
          },
        })

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
