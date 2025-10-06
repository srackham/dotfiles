return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local telescope = require 'telescope'
      local builtin = require('telescope.builtin')

      telescope.setup({
        -- Default layout
        defaults = {
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              preview_cutoff = 100,
              prompt_position = 'bottom',
              width = { padding = 0 },  -- Use full width
              height = { padding = 0 }, -- Use full height
              preview_width = 0.5,      -- Preview width as a fraction of the total width
            },
            vertical = {
              width = { padding = 0 },
              height = { padding = 0 },
              preview_height = 0.5,
            },
          },
        },
      })

      -- Key bindings
      local list_buffers = function()
        vim.cmd("OutlineFocusCode")
        builtin.buffers({ sort_mru = true, ignore_current_buffer = true })
      end
      local list_oldfiles = function()
        vim.cmd("OutlineFocusCode")
        builtin.oldfiles({ sort_mru = true, ignore_current_buffer = true })
      end
      local find_files = function()
        vim.cmd("OutlineFocusCode")
        builtin.find_files({
          find_command = { 'rg', '--files', '--hidden', "--sortr", "modified" }
        })
      end
      local live_grep = function()
        vim.cmd("OutlineFocusCode")
        vim.cmd('wa')
        builtin.live_grep({
          additional_args = { '--hidden' },
        })
      end
      vim.keymap.set({ 'n', 'v' }, '<M-\\>', list_buffers, { desc = "List buffers" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>bb', list_buffers, { desc = "List buffers" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>.', list_buffers, { desc = "List buffers" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fo', list_oldfiles, { desc = "List previously opened files" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>ff', find_files, { desc = "Find files" })
      vim.keymap.set({ 'n', 'v' }, '<C-M-\\>', find_files, { desc = "Find files" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fc', builtin.current_buffer_fuzzy_find,
        { desc = "Current buffer fuzzy find" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fg', live_grep, { desc = "Live-grep files" })
      vim.keymap.set({ 'n', 'v' }, '<leader>fG', function()
        builtin.live_grep({ search_dirs = { vim.fn.expand('%:p') } })
      end, { desc = "Live-grep current file" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fh', builtin.highlights, { desc = "List highlights" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fk', builtin.keymaps, { desc = "List normal mode key mappings" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fw', builtin.grep_string, { desc = "Search files for word or selection" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>cd', builtin.diagnostics,
        { desc = "List diagnostic messages with Telescope" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fr', builtin.resume, { desc = "Resume last Telescope picker" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>hh', builtin.help_tags, { desc = "Search documentation" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fp', function()
        builtin.live_grep({
          cwd = vim.fn.stdpath('data') .. '/lazy/'
        })
      end, { desc = "Live-grep plugin files" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>cr', builtin.lsp_references,
        { desc = "List references to word under cursor" })
      local symbols = {
        'function',
        'method',
        'constructor',
        'class',
        'interface',
        'struct',
        'enum',
        'constant',
        'type', }
      vim.keymap.set({ 'n', 'v' }, '<Leader>cs', function()
        require('telescope.builtin').lsp_document_symbols({ symbols = symbols })
      end, { noremap = true, silent = true, desc = "List symbols" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>cS', function()
        require('telescope.builtin').lsp_dynamic_workspace_symbols({ symbols = symbols })
      end, { noremap = true, silent = true, desc = "Live-grep workspace symbols" })
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
                preview_width = 0.6,
              },
              sorting_strategy = 'ascending',
            },
          },
        }
      }
      telescope.load_extension('heading')
      vim.keymap.set({ 'n', 'v' }, '<Leader>ms', telescope.extensions.heading.heading,
        { desc = "Markdown section headers picker" })
    end,
  },
}
