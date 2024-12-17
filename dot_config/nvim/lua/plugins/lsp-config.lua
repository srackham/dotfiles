return {
  {
    "williamboman/mason.nvim",
    config = function()
      require "mason".setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require "mason-lspconfig".setup({
        ensure_installed = { "gopls", "lua_ls", "ts_ls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require "lspconfig"
      local opts = {}
      lspconfig.gopls.setup({})
      lspconfig.lua_ls.setup({})
      lspconfig.ts_ls.setup({})
      lspconfig.gleam.setup({})
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<Leader>lf', function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end,
  },
}
