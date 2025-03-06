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
      vim.keymap.set('n', '<Leader>fH', builtin.highlights, { desc = "List highlights" })
      vim.keymap.set('n', '<Leader>fk', builtin.keymaps, { desc = "List normal mode key mappings" })
      vim.keymap.set('n', '<Leader>fm', function() builtin.marks({ previewer = false }) end, { desc = "List marks" })
      vim.keymap.set('n', '<Leader>fr', builtin.registers, { desc = "List registers" })
      vim.keymap.set('n', '<Leader>fs', builtin.grep_string, { desc = "Search files for word or selection" })
      vim.keymap.set('n', '<Leader>fz', builtin.spell_suggest, { desc = "Show spelling suggestions" })
      vim.keymap.set('n', '<Leader>ld', builtin.diagnostics, { desc = "List diagnostics" })
      vim.keymap.set('n', '<Leader>lr', builtin.lsp_references, { desc = "List references to word under cursor" })
      vim.keymap.set('n', '<Leader>T', builtin.resume, { desc = "Resume last Telescope picker" })
      vim.keymap.set('n', '<Leader>H', builtin.help_tags, { desc = "Search documentation" })
      vim.keymap.set('n', '<Leader>fp', function()
        builtin.live_grep({
          cwd = vim.fn.stdpath('data') .. '/lazy/'
        })
      end, { desc = "Live-grep plugin files" })
    end,
  },

  -- Telescope extensions
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      local telescope = require 'telescope'
      local actions = require('telescope.actions')
      telescope.setup {
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
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {}
          },
        }
      }
      require 'telescope'.load_extension('ui-select')
    end,
  },
  {
    'crispgm/telescope-heading.nvim',
    config = function()
      local telescope = require 'telescope'
      telescope.setup {
        extensions = {
          heading = {
            treesitter = true,
            picker_opts = {
              layout_config = {
                width = 0.9,
                preview_width = 0.6,
                preview_cutoff = 100,
              },
              sorting_strategy = 'ascending',
              layout_strategy = 'horizontal',
            },
          },
        }
      }
      telescope.load_extension('heading')
      vim.keymap.set('n', '<Leader>fh', telescope.extensions.heading.heading, { desc = "List headings" })
    end,
  },
}
