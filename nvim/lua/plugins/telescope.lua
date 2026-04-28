return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim',    build = 'make' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
    },
    config = function()
      local telescope = require('telescope')
      local lga_actions = require('telescope-live-grep-args.actions')
      local actions = require('telescope.actions')
      telescope.setup {
        defaults = require('telescope.themes').get_ivy({
          layout_config = {
            preview_cutoff = 100,
            preview_width = 0.6,
          },
        }),
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ['<C-k>'] = lga_actions.quote_prompt(),
                ['<C-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
                ['<C-space>'] = actions.to_fuzzy_refine,
              },
            },
          },
        },
      }
      telescope.load_extension('fzf')
      telescope.load_extension('live_grep_args')
    end,
  },
}
