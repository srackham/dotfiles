-- Use vim.g to persist state across file re-evaluations
-- Sets whether Harper is enabled at startup
vim.g.harper_enabled = false

--- Reattach Harper LSP to current and future buffers
local function start_clients()
  vim.cmd "lsp enable harper"
  -- vim.lsp.enable("harper", true)
  vim.g.harper_enabled = true
  vim.notify "Harper LSP server enabled"
end

--- Stop all harper LSP clients
local function stop_clients()
  vim.cmd "lsp disable harper"
  -- vim.lsp.enable("harper", false) -- Prevents auto-attaching to future buffers
  vim.g.harper_enabled = false
  vim.notify "Harper LSP server disabled"
end

vim.keymap.set("n", "<Leader>dg", function()
  if vim.g.harper_enabled then
    stop_clients()
  else
    start_clients()
  end
end, { desc = "Toggle Harper LSP server on/off" })

-- Establish the initial state once Neovim has loaded and the Harper LSP is configured.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      if not vim.g.harper_enabled then
        stop_clients()
      end
    end)
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
