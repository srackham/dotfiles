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
      vim.keymap.set('n', '<Leader>fw', builtin.grep_string, { desc = "Search files for word or selection" })
      vim.keymap.set('n', '<Leader>fz', builtin.spell_suggest, { desc = "Show spelling suggestions" })
      vim.keymap.set('n', '<Leader>ld', builtin.diagnostics, { desc = "List diagnostics" })
      vim.keymap.set('n', '<Leader>T', builtin.resume, { desc = "Resume last Telescope picker" })
      vim.keymap.set('n', '<Leader>H', builtin.help_tags, { desc = "Search documentation" })
      vim.keymap.set('n', '<Leader>fp', function()
        builtin.live_grep({
          cwd = vim.fn.stdpath('data') .. '/lazy/'
        })
      end, { desc = "Live-grep plugin files" })
      vim.keymap.set('n', '<Leader>lr', builtin.lsp_references, { desc = "List references to word under cursor" })
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
      vim.keymap.set('n', '<Leader>ls', function()
        require('telescope.builtin').lsp_document_symbols({ symbols = symbols })
      end, { noremap = true, silent = true, desc = "List LSP document symbols" })
      vim.keymap.set('n', '<Leader>lS', function()
        require('telescope.builtin').lsp_dynamic_workspace_symbols({ symbols = symbols })
      end, { noremap = true, silent = true, desc = "Live-grep LSP workspace symbols" })
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
      vim.keymap.set('n', '<Leader>fh', telescope.extensions.heading.heading, { desc = "List headings" })
    end,
  },
  {
    'srackham/better-digraphs.nvim',
    branch = 'bugfixes', -- My bugfix branch
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      vim.keymap.set('i', '<C-k><C-k>', function()
        require('better-digraphs').digraphs('insert')
      end, { noremap = true, silent = true, desc = "List digraphs" })
      vim.g.BetterDigraphsAdditions = {
        { digraph = 'SM', symbol = '☺', name = 'SMILING FACE' },
        { digraph = 'FR', symbol = '☹', name = 'FROWNING FACE' },
        { digraph = 'HT', symbol = '♥', name = 'HEART' },
        { digraph = 'ST', symbol = '★', name = 'STAR' },
        { digraph = 'CK', symbol = '✓', name = 'CHECK MARK' },
        { digraph = 'XX', symbol = '✗', name = 'CROSS MARK' },
        { digraph = 'SN', symbol = '☃', name = 'SNOWMAN' },
        { digraph = 'SU', symbol = '☀', name = 'SUN' },
        { digraph = 'MN', symbol = '☽', name = 'MOON' },
        { digraph = 'CL', symbol = '☁', name = 'CLOUD' },
        { digraph = 'UM', symbol = '☂', name = 'UMBRELLA' },
        { digraph = 'FL', symbol = '⚑', name = 'FLAG' },
        { digraph = 'WR', symbol = '✎', name = 'PENCIL' },
        { digraph = 'SC', symbol = '✂', name = 'SCISSORS' },
        { digraph = 'TM', symbol = '™', name = 'TRADEMARK' },
        { digraph = 'CO', symbol = '©', name = 'COPYRIGHT' },
        { digraph = 'RG', symbol = '®', name = 'REGISTERED' },
        { digraph = 'DG', symbol = '°', name = 'DEGREE' },
        { digraph = 'PI', symbol = 'π', name = 'PI' },
        { digraph = 'IN', symbol = '∞', name = 'INFINITY' },
        { digraph = 'DG', symbol = '†', name = 'DAGGER' },
        { digraph = 'EL', symbol = '…', name = 'ELLIPSIS' },
        { digraph = 'EM', symbol = '—', name = 'EM DASH' },
        { digraph = 'NE', symbol = '≠', name = 'NOT EQUAL' },
        { digraph = 'OK', symbol = '✓', name = 'CHECK MARK' },
        { digraph = 'VE', symbol = '⋮', name = 'VERTICAL ELLIPSIS' },
        { digraph = 'XX', symbol = '✗', name = 'CROSS MARK' },
        { digraph = 'RA', symbol = '→', name = 'RIGHT ARROW' },
        { digraph = 'LA', symbol = '←', name = 'LEFT ARROW' },
        { digraph = 'UA', symbol = '↑', name = 'UP ARROW' },
        { digraph = 'DA', symbol = '↓', name = 'DOWN ARROW' },
        { digraph = 'LQ', symbol = '“', name = 'LEFT DOUBLE QUOTE' },
        { digraph = 'RQ', symbol = '”', name = 'RIGHT DOUBLE QUOTE' },
        { digraph = 'BU', symbol = '•', name = 'BULLET' },
        { digraph = 'PL', symbol = '±', name = 'PLUS MINUS' },
        { digraph = 'SQ', symbol = '√', name = 'SQUARE ROOT' },
        { digraph = 'AE', symbol = '≈', name = 'APPROXIMATELY EQUAL' },
        { digraph = 'LE', symbol = '≤', name = 'LESS THAN OR EQUAL' },
        { digraph = 'GE', symbol = '≥', name = 'GREATER THAN OR EQUAL' },
        { digraph = "PP", symbol = "¶", name = "PARAGRAPH SIGN" },
      }
    end,
  },
}
