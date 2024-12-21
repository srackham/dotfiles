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
        ensure_installed = { 'gopls', 'lua_ls', 'ts_ls' },
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
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.gleam.setup({
        capabilities = capabilities,
      })
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
      vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.rename)
      vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action)
      vim.keymap.set('n', '<Leader>lf', function()
        vim.lsp.buf.format { async = true }
      end)
    end,
  },
}
