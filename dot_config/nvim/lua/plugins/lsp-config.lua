return {
  {
    'williamboman/mason.nvim',
    version = '^1.0.0', -- Pinned to latest v1.x version
    config = function()
      require 'mason'.setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    version = '^1.0.0', -- Pinned to latest v1.x version
    config = function()
      require 'mason-lspconfig'.setup({
        ensure_installed = { 'gopls', 'jsonls', 'lua_ls', 'ts_ls', 'denols' },
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require 'lspconfig'
      lspconfig.gopls.setup({
        capabilities = capabilities,
      })
      lspconfig.jsonls.setup({
        capabilities = capabilities,
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } } -- Suppress undefined global 'vim' warnings
          }
        }
      })
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        root_dir = function()
          if lspconfig.util.root_pattern('deno.json', 'deno.jsonc')() then
            return nil -- If it's a Deno project don't attach the ts_ls LSP
          else
            return lspconfig.util.root_pattern('package.json')()
          end
        end,
        single_file_support = false
      })
      lspconfig.denols.setup({
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),

      })
      lspconfig.gleam.setup({
        capabilities = capabilities,
      })
      lspconfig.marksman.setup({
      })

      local border_style = 'rounded' -- floating window border style

      -- Add rounded borders to LSP hover and signature help
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = border_style }
      )

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help, { border = border_style }
      )

      -- Add rounded borders to diagnostic float windows
      vim.diagnostic.config({
        float = { border = border_style }
      })

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
      vim.keymap.set('n', '<Leader>ld', function()
        local enable = not vim.diagnostic.config().virtual_text
        vim.diagnostic.config({ virtual_text = enable })
        local status = enable and "enabled" or "disabled"
        vim.notify("Diagnostics virtual text " .. status)
      end, { silent = true, noremap = true, desc = "Toggle on-screen diagnostic messages" })

      -- Popup (floating) window mappings
      vim.keymap.set('n', '<Leader>pd', vim.lsp.buf.hover,
        { desc = "Show documentation popup for the symbol under the cursor" })
      vim.keymap.set('n', '<Leader>ps', vim.lsp.buf.signature_help,
        { desc = "Show function signature popup" })
      vim.keymap.set('n', '<Leader>pe', vim.diagnostic.open_float,
        { desc = "Show diagnostic message popup" })
    end,
  },
}
