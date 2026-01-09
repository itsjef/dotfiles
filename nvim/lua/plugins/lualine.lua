return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'SmiteshP/nvim-navic',
  },
  config = function()
    local navic = require('nvim-navic')

    -- Cache for persisting context across buffer switches
    local last_context = ''

    local function get_navic_location()
      -- Return cached context for terminal buffers
      if vim.bo.buftype == 'terminal' then
        return last_context
      end

      -- Get location from navic if available
      if navic.is_available() then
        local location = navic.get_location()
        if location and location ~= '' then
          last_context = location
          return location
        end
      end

      -- Return cached context if navic has nothing
      return last_context
    end

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        globalstatus = true, -- overrides vim.o.laststatus
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {
          { 'filename', path = 1 },
          {
            get_navic_location,
            color = function()
              -- Try to get color from navic highlight group
              local hl = vim.api.nvim_get_hl(0, { name = 'NavicText', link = false })
              if hl.fg then
                return { fg = string.format('#%06x', hl.fg) }
              end

              -- Fallback to Function highlight group (often cyan/blue)
              hl = vim.api.nvim_get_hl(0, { name = 'Function', link = false })
              if hl.fg then
                return { fg = string.format('#%06x', hl.fg) }
              end

              -- Last fallback to Special highlight group
              hl = vim.api.nvim_get_hl(0, { name = 'Special', link = false })
              if hl.fg then
                return { fg = string.format('#%06x', hl.fg) }
              end

              -- Default fallback
              return { fg = '#61afef' }
            end
          }
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'searchcount', 'progress', 'location' },
        lualine_z = { { 'datetime', style = '%H:%M' } }
      },
      inactive_sections = {},
      tabline = {},
      extensions = {}
    }
  end,
}
