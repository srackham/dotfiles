return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<Leader>f', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<Leader>b', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<Leader>/', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<Leader>?', builtin.help_tags, { desc = 'Telescope help tags' })
    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup {
        pickers = {
          find_files = {
            hidden = true,
          },
        },
        defaults = {
          file_ignore_patterns = { "^.git/", "^node_modules/" },
          mappings = {
            i = {
              ["<esc>"] = actions.close,
            },
          },
        },
        -- Add the telescope-ui-select extension to Telescope
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          }
        }
      }
      require("telescope").load_extension("ui-select")
    end,
  },
}
