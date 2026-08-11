-- Load LSP config files in ~/.config/nvim/lsp/ then activate the LSP servers.

vim.lsp.enable {
  "bashls",
  "cssls",
  "denols",
  "gleam",
  "gopls",
  "harper",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "nixd",
  "pyright",
  "ruff",
  "rust_analyzer",
  "ts_ls",
}

-- Shared diagnostic config
vim.diagnostic.config {
  virtual_text = false,
  virtual_lines = true,
  severity_sort = true, -- Highly recommended in 0.12 to prioritize errors over warnings/hints in UI
}

-- LSP related keymaps
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "<Leader>cR", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<Leader>dt", function()
  local enable = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config { virtual_lines = enable }
  local status = enable and "enabled" or "disabled"
  vim.notify("Diagnostics virtual text " .. status)
end, { desc = "Toggle diagnostics virtual text" })

local diag_errors_only = false

vim.keymap.set("n", "<Leader>dT", function()
  diag_errors_only = not diag_errors_only
  vim.diagnostic.config {
    virtual_lines = diag_errors_only and { severity = vim.diagnostic.severity.ERROR } or true,
  }
  vim.notify("LSP virtual_lines: " .. (diag_errors_only and "errors only" or "all"))
end, { desc = "Toggle LSP diagnostics: all vs errors only" })
