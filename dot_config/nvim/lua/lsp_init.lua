-- Load LSP config files in ~/.config/nvim/lsp/ then activate the LSP servers.
vim.lsp.enable({ 'lua_ls', 'tsserver', 'denols', 'rust_analyzer', 'bashls', 'marksman', 'gleam', 'nixd' })

-- Shared diagnostic config
vim.diagnostic.config {
  virtual_text = true,
}

-- LSP relaated keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
vim.keymap.set("n", "<Leader>cR", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<Leader>cA", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<Leader>cf", function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format buffer" })
vim.keymap.set("n", "<Leader>cv", function()
  local enable = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config { virtual_text = enable }
  local status = enable and "enabled" or "disabled"
  vim.notify("Diagnostics virtual text " .. status)
end, { desc = "Toggle diagnostics virtual text" })

-- Auto-format files on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- Ignore errors for file types without formatters
    pcall(function()
      vim.lsp.buf.format({ async = false })
    end)
  end,
})
