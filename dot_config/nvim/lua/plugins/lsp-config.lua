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

      -- Add rounded borders to LSP hover and signature help
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = 'rounded' }
      )

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = 'rounded' }
      )

      -- Add rounded borders to diagnostic float windows
      vim.diagnostic.config({
        float = {
          border = 'rounded'
        }
      })

      -- LSP key mappings
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
        { desc = "Go to the definition of the symbol under the cursor" })
      vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition,
        { desc = "Go to the type definition of the symbol under the cursor" })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover,
        { desc = "Display documentation for the symbol under the cursor" })
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
        { desc = "Display function signature information for the symbol under the cursor" })
      vim.keymap.set('n', '<Leader>lR', vim.lsp.buf.rename,
        { desc = "Rename all instances of the symbol under the cursor" })
      vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action,
        { desc = "Select a code action available at the current cursor position" })
      vim.keymap.set('n', '<Leader>lf', function()
        vim.lsp.buf.format { async = true }
      end, { desc = "Format document" })
      vim.keymap.set('n', '<Leader>ld', function()
        vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
      end, { silent = true, noremap = true, desc = "Toggle on-screen diagnostic messages" })
    end,
  },
}
