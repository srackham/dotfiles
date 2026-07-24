
local virtual_text_enabled = true

vim.keymap.set("n", "<Leader>dh", function()
  local clients = vim.lsp.get_clients { name = "harper" }
  if #clients == 0 then
    vim.notify("harper-ls not attached", vim.log.levels.WARN)
    return
  end

  local client = clients[1]
  local ns = vim.lsp.diagnostic.get_namespace(client.id)
  virtual_text_enabled = not virtual_text_enabled
  vim.diagnostic.config({ virtual_text = virtual_text_enabled }, ns)
  vim.notify("Harper LSP diagnostics " .. (virtual_text_enabled and "enabled" or "disabled"))

end, { desc = "Toggle Harper LSP diagnostics virtual text" })

return {
  cmd = { "harper-ls", "--stdio" },
  root_markers = { ".git" },

  filetypes = {
    "markdown",
    "text",
    "typst",
    "tex",
    "lua",
    "python",
    "rust",
    "go",
    "javascript",
    "typescript",
    "c",
    "cpp",
  },

  settings = {
    ["harper-ls"] = {
      userDictPath = "~/.config/harper/dict.txt",
      diagnosticSeverity = "hint",

      linters = { -- See https://writewithharper.com/docs/rules
        SpellCheck = false,
        SpelledNumbers = false,
        AnA = true,
        LongSentences = false,
        SentenceCapitalization = true,
        RepeatedWords = true,
        Spaces = true,
        UseTitleCase = false,
      },
    },
  },
}
