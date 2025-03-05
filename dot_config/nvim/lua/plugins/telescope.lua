return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local builtin = require('telescope.builtin')
      local list_buffers = function()
        builtin.buffers({ sort_mru = true, ignore_current_buffer = true })
      end
      local find_files = function()
        builtin.find_files({
          find_command = { 'rg', '--files', '--hidden', "--sortr", "modified" }
        })
      end
      local live_grep = function()
        vim.cmd('wa')
        builtin.live_grep({
          additional_args = { '--hidden' },
        })
      end

      vim.keymap.set('n', '\\', list_buffers, { desc = "List buffers" })
      vim.keymap.set('n', '<Leader>fb', list_buffers, { desc = "List buffers" })
      vim.keymap.set('n', '<Leader>ff', find_files, { desc = "Find files" })
      vim.keymap.set('n', '<Leader>fg', live_grep, { desc = "Live-grep files" })
      vim.keymap.set('n', '<Leader>fh', builtin.highlights, { desc = "List highlights" })
      vim.keymap.set('n', '<Leader>fk', builtin.keymaps, { desc = "List normal mode key mappings" })
      vim.keymap.set('n', '<Leader>fm', function() builtin.marks({ previewer = false }) end, { desc = "List marks" })
      vim.keymap.set('n', '<Leader>fs', builtin.grep_string, { desc = "Find string under cursor or selection" })
      vim.keymap.set('n', '<Leader>fz', builtin.spell_suggest, { desc = "Show spelling suggestions" })
      vim.keymap.set('n', '<Leader>ld', builtin.diagnostics, { desc = "List diagnostics" })
      vim.keymap.set('n', '<Leader>lr', builtin.lsp_references, { desc = "List references to word under cursor" })
      vim.keymap.set('n', '<Leader>T', builtin.resume, { desc = "Resume last Telescope picker" })
      vim.keymap.set('n', '<Leader>H', builtin.help_tags, { desc = "Search documentation" })

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
          find_command = { 'rg', '--files', '--hidden', "--sortr", "modified", '--glob', '**/*.' .. ext }
        })
      end)

      map_extension_filter('<Leader>fG', "Telescope filtered live-grep", function()
        vim.cmd('wa')
        builtin.live_grep({
          prompt_title = "Live Live-grep ." .. ext .. " Files",
          additional_args = { '--hidden' },
          glob_pattern = '**/*.' .. ext,
        })
      end)

      map_extension_filter('<Leader>fS', "Telescope filtered find string", function()
        vim.cmd('wa')
        builtin.grep_string({
          prompt_title = "Find string in ." .. ext .. " Files",
          additional_args = { '--hidden' },
          glob_pattern = '**/*.' .. ext,
        })
      end)

      vim.keymap.set('n', '<Leader>fp', function()
        builtin.live_grep({
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
          highlights = {
            layout_strategy = 'vertical',
          },
        },
        defaults = {
          file_ignore_patterns = { '^.git/', '^node_modules/' },
          mappings = {
            i = {
              ['<Esc>'] = actions.close,
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
