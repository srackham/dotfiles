return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<Leader>H', builtin.help_tags, { desc = "Search documentation" })
      vim.keymap.set('n', '<Leader>T', builtin.resume, { desc = "Resume last Telescope picker" })
      vim.keymap.set('n', '<Leader>fb', builtin.buffers, { desc = "List buffers" })
      vim.keymap.set('n', '<Leader>fc', builtin.grep_string, { desc = "Find string under cursor or selection" })
      vim.keymap.set('n', '<Leader>ff', builtin.find_files, { desc = "Find files" })
      vim.keymap.set('n', '<Leader>fg', function()
        builtin.live_grep({
          additional_args = { '--hidden' },
        })
      end, { desc = "Live-grep files" })
      vim.keymap.set('n', '<Leader>fk', builtin.keymaps, { desc = "List normal mode key mappings" })
      vim.keymap.set('n', '<Leader>fs', builtin.spell_suggest, { desc = "Show spelling suggestions" })

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

      map_extension_filter('<Leader>fF', "Telescope filtered find files", function()
        builtin.find_files({
          prompt_title = "Find ." .. ext .. " Files",
          find_command = { 'rg', '--files', '--hidden', '--glob', '**/*.' .. ext }
        })
      end)

      map_extension_filter('<Leader>fG', "Telescope filtered live-grep", function()
        builtin.live_grep({
          prompt_title = "Live Live-grep ." .. ext .. " Files",
          additional_args = { '--hidden' },
          glob_pattern = '**/*.' .. ext,
        })
      end)

      map_extension_filter('<Leader>fC', "Telescope filtered find string", function()
        builtin.grep_string({
          prompt_title = "Find string in ." .. ext .. " Files",
          additional_args = { '--hidden' },
          glob_pattern = '**/*.' .. ext,
        })
      end)

      vim.keymap.set('n', '<Leader>fp', function()
        require('telescope.builtin').live_grep({
          cwd = vim.fn.stdpath('data') .. '/lazy/'
        })
      end, { desc = "Live-grep plugin files" })
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
