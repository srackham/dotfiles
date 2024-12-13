return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>?', builtin.help_tags, { desc = 'Telescope help tags' })
    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup {
        -- A single Esc closes the picker (https://www.reddit.com/r/neovim/comments/pzxw8h/telescope_quit_on_first_single_esc/)
        defaults = {
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
