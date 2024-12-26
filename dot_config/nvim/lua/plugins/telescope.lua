return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<Leader>ff', builtin.find_files, { desc = "Find files" })
      vim.keymap.set('n', '<Leader>fb', builtin.buffers, { desc = "List buffers" })
      vim.keymap.set('n', '<Leader>fd', builtin.diagnostics, { desc = "List LSP diagnostics" })
      vim.keymap.set('n', '<Leader>fg', builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set('n', '<Leader>fh', builtin.help_tags, { desc = "Search documentation" })
      vim.keymap.set('n', '<Leader>fr', builtin.lsp_references, { desc = "Find LSP references to word under cursor" })
      vim.keymap.set('n', '<Leader>fs', builtin.spell_suggest, { desc = "Show spelling suggestions" })
      vim.keymap.set('n', '<Leader>fk', builtin.keymaps, { desc = "List normal mode key mappings" })

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

      map_extension_filter('<Leader>fG', "Telescope filtered live grep", function()
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
