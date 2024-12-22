return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', 'tf', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', 'tb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', 'tg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', 'th', builtin.help_tags, { desc = 'Telescope help tags' })

      local ext = ''
      local function map_extension_filter(cmd, desc, callback)
        vim.keymap.set('n', cmd, function()
          vim.ui.input({ prompt = "Enter file name extension: ", default = ext }, function(input)
            if input ~= nil and #input > 0 then
              ext = input
              callback()
            end
          end)
        end, { desc = desc })
      end

      map_extension_filter('tF', "Telescope filtered find files", function()
        builtin.find_files({
          prompt_title = "Find ." .. ext .. " Files",
          find_command = { 'rg', '--files', '--hidden', '--glob', '**/*.' .. ext }
        })
      end)

      map_extension_filter('tG', "Telescope filtered live grep", function()
        builtin.live_grep({
          prompt_title = "Live Grep ." .. ext .. " Files",
          glob_pattern = '**/*.' .. ext,
        })
      end)
    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
        pickers = {
          find_files = {
            hidden = true,
          },
        },
        defaults = {
          file_ignore_patterns = { '^.git/', '^node_modules/' },
          mappings = {
            i = {
              ['<esc>'] = actions.close,
            },
          },
        },
        -- Add the telescope-ui-select extension to Telescope
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {}
          }
        }
      }
      require('telescope').load_extension('ui-select')
    end,
  },
}
