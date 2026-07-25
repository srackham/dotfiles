local harper_enabled = true -- track whether harper is enabled

--- Disable: stop all harper LSP clients
local function stop_all_clients()
  local clients = vim.lsp.get_clients { name = "harper" }
  for _, client in ipairs(clients) do
    client:stop()
  end
end

vim.keymap.set("n", "<Leader>dg", function()
  if harper_enabled then
    vim.schedule(function()
      stop_all_clients()
    end)
    harper_enabled = false
    vim.notify "Harper LSP server disabled"
  else
    -- Enable: reattach harper to current and future buffers
    vim.lsp.enable "harper"
    harper_enabled = true
    vim.notify "Harper LSP server enabled"
  end
end, { desc = "Toggle Harper LSP server on/off" })

-- When a file is opened turn the Harper LSP off if it is currently disabled.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function()
    if not harper_enabled then
      vim.schedule(function()
        stop_all_clients()
      end)
    end
  end,
})

return {
  cmd = { "harper-ls", "--stdio" },
  root_markers = { ".git" },
  filetypes = {
    "markdown",
    "text",
  },
  settings = {
    ["harper-ls"] = {
      userDictPath = "~/.config/harper/dict.txt",
      diagnosticSeverity = "hint",

      linters = { -- See https://writewithharper.com/docs/rules
        SpellCheck = false, -- The Vim spell checker is used for spelling
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
