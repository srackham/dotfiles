local harper_enabled = true -- track whether harper is enabled

vim.keymap.set("n", "<Leader>dh", function()
  local clients = vim.lsp.get_clients { name = "harper" }

  if harper_enabled then
    -- Disable: stop all harper clients
    for _, client in ipairs(clients) do
      client:stop()
    end
    harper_enabled = false
    vim.notify "Harper LSP server disabled"
  else
    -- Enable: re-attach harper to current and future buffers
    vim.lsp.enable "harper"
    harper_enabled = true
    vim.notify "Harper LSP server enabled"
  end
end, { desc = "Toggle Harper LSP server on/off" })

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
        SpellCheck = true,
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
