return {
  -- Mason LSP server manager
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
    },
    opts = {
      ensure_installed = { 'gopls', 'jsonls', 'lua_ls', 'ts_ls', 'denols', 'bashls' },
    },
  },
}
