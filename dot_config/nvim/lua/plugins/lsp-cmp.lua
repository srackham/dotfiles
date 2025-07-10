--[[

# Combined LSP, completions and snippets plugin configurations file

## Snippets
Aside from the `friendly-snippets` dependency there's nothing to set up.

Blink uses the `vim.snippet` API by default for expanding and navigating snippets. The built-in
`snippets` source will load [friendly-snippets](https://github.com/rafamadriz/friendly-snippets), if
available, and load any snippets found at `~/.config/nvim/snippets/`.

By default, the snippets source will check ~/.config/nvim/snippets for your custom snippets, but you
may add additional folders via sources.providers.snippets.opts.search_paths. Currently, only VSCode
style snippets are supported, but you may look into Luasnip if you'd like more advanced
functionality.

See:

- https://cmp.saghen.dev/configuration/snippets.html

]]


return {
  -- Mason LSP server manager
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
    },
    opts = {
      ensure_installed = { 'gopls', 'jsonls', 'lua_ls', 'ts_ls', 'denols' },
    },
  },

  -- LSP configurations
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require 'lspconfig'

      -- Configure LSP servers
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim', 'Obsidian' } -- Suppress undefined global warnings
            },
          }
        }
      }
      lspconfig.ts_ls.setup {
        root_dir = function()
          if lspconfig.util.root_pattern('deno.json', 'deno.jsonc')() then
            return nil -- If it's a Deno project don't attach the ts_ls LSP
          else
            return lspconfig.util.root_pattern('package.json')()
          end
        end,
        single_file_support = false
      }
      lspconfig.denols.setup {
        root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
      }

      -- Configure diagnostic message UI
      vim.diagnostic.config {
        -- float = { border = border_style },
        -- virtual_lines = { current_line = true },
        virtual_text = true,
      }

      -- LSP key mappings
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
        { desc = "Go to the definition of the symbol under the cursor" })
      vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition,
        { desc = "Go to the type definition of the symbol under the cursor" })
      vim.keymap.set('n', '<Leader>cR', vim.lsp.buf.rename,
        { desc = "Rename all instances of the symbol under the cursor" })
      vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action,
        { desc = "Select a code action available at the current cursor position" })
      vim.keymap.set('n', '<Leader>cf', function()
        vim.lsp.buf.format { async = true }
      end, { desc = "Format buffer" })
      vim.keymap.set('n', '<Leader>cD', function()
        local enable = not vim.diagnostic.config().virtual_text
        vim.diagnostic.config { virtual_text = enable }
        local status = enable and "enabled" or "disabled"
        vim.notify("Diagnostics virtual text " .. status)
      end, { silent = true, noremap = true, desc = "Toggle on-screen diagnostic messages" })
    end,
  },

  -- Completion engine: blink.cmp
  {
    'saghen/blink.cmp',
    version = '1.*', -- Use a release tag to download pre-built binaries

    dependencies = {
      'rafamadriz/friendly-snippets',
    },

    -- See https://cmp.saghen.dev/installation.html for options
    config = function()
      local cmp = require('blink.cmp')
      local cmp_enabled = true

      cmp.setup {
        keymap = {
          preset = 'default',
          ["<C-Space>"] = { "select_and_accept" },
        },
        appearance = {
          nerd_font_variant = 'mono'
        },
        completion = {
          menu = {
            border = "single",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          },
          documentation = {
            auto_show = true,
            window = {
              border = "single",
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
            },
          },
        },
        cmdline = { enabled = false },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
          providers = {
            snippets = {
              min_keyword_length = 2,
              score_offset = 4,
            },
            lsp = {
              min_keyword_length = 3,
              score_offset = 3,
            },
            path = {
              min_keyword_length = 3,
              score_offset = 2,
            },
            buffer = {
              min_keyword_length = 5,
              score_offset = 1,
            },
          },
        },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
        enabled = function()
          return cmp_enabled
        end,
      }

      local function toggle_completions()
        cmp_enabled = not cmp_enabled
        vim.notify("Completions " .. (cmp_enabled and "enabled" or "disabled"))
      end
      vim.keymap.set("n", "<leader>ct", toggle_completions,
        { noremap = true, silent = true, desc = "Toggle completions" })
      vim.keymap.set({ "i", "n" }, "<C-M-Space>", toggle_completions,
        { noremap = true, silent = true, desc = "Toggle completions" })
    end,

    opts_extend = { 'sources.default' },
  },
}
