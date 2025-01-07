return {
  {
    'williamboman/mason.nvim',
    config = function()
      require 'mason'.setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require 'mason-lspconfig'.setup({
        ensure_installed = { 'gopls', 'jsonls', 'lua_ls', 'ts_ls' },
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
      })
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.gleam.setup({
        capabilities = capabilities,
      })

      -- Add rounded borders to LSP hover and signature help
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = "rounded" }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = "rounded" }
      )

      -- Add rounded borders to diagnostic float windows
      vim.diagnostic.config({
        float = {
          border = "rounded"
        }
      })

      -- LSP key mappings
      vim.keymap.set('n', 'K', vim.lsp.buf.hover,
        { desc = "Display documentation for the symbol under the cursor" })
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
        { desc = "Display function signature information" })
      vim.keymap.set('n', '<Leader>jD', vim.lsp.buf.declaration,
        { desc = "Jump to the declaration of the symbol" })
      vim.keymap.set('n', '<Leader>jd', vim.lsp.buf.definition,
        { desc = "Jump to the definition of the symbol under the cursor" })
      vim.keymap.set('n', '<Leader>lR', vim.lsp.buf.rename,
        { desc = "Rename all references to the symbol under the cursor" })
      vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action,
        { desc = "Select a code action available at the current cursor position" })
      vim.keymap.set('n', '<Leader>lf', function()
        vim.lsp.buf.format { async = true }
      end, { desc = "Format document using LSP" })
    end,
  },
}
