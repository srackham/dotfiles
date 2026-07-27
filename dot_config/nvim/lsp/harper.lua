local harper_enabled = true -- track whether harper is enabled

--- Reattach Harper LSP to current and future buffers
local function start_clients()
  vim.lsp.enable("harper", true)
  harper_enabled = true
  vim.notify "Harper LSP server enabled"
end

--- Disable: stop all harper LSP clients
local function stop_clients()
  vim.lsp.enable("harper", false) -- Prevents auto-attaching to future buffers
  local clients = vim.lsp.get_clients { name = "harper" }
  for _, client in ipairs(clients) do
    client:stop()
  end
  harper_enabled = false
  vim.notify "Harper LSP server disabled"
end

vim.keymap.set("n", "<Leader>dg", function()
  if harper_enabled then
    vim.schedule(function()
      stop_clients()
    end)
  else
    vim.schedule(function()
      start_clients()
    end)
  end
end, { desc = "Toggle Harper LSP server on/off" })

-- When a file is opened turn the Harper LSP off if it is currently disabled.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function()
    if not harper_enabled then
      vim.schedule(function()
        stop_clients()
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
        SpellCheck = true, -- The Vim spell checker is used for spelling
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
