-- Combined LSP and completions plugin configurations file

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
      lspconfig.marksman.setup {} -- Marksman is not managed by Mason so needs explicit default setup
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' } -- Suppress undefined global 'vim' warnings
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
      vim.keymap.set('n', '<Leader>lR', vim.lsp.buf.rename,
        { desc = "Rename all instances of the symbol under the cursor" })
      vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action,
        { desc = "Select a code action available at the current cursor position" })
      vim.keymap.set('n', '<Leader>lf', function()
        vim.lsp.buf.format { async = true }
      end, { desc = "Format buffer" })
      vim.keymap.set('n', '<Leader>lt', function()
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
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',

    -- See https://cmp.saghen.dev/installation.html for options
    opts = {
      keymap = {
        preset = 'default',
        ["<C-Space>"] = { "select_and_accept" },
      },
      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = { documentation = { auto_show = true } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' }
    },
    opts_extend = { 'sources.default' }
  },
}
