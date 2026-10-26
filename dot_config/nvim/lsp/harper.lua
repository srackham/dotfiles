-- Use vim.g to persist state across file re-evaluations
-- Sets whether Harper is enabled at startup
vim.g.harper_enabled = false

--- Reattach Harper LSP to current and future buffers
local function start_lsp()
  vim.lsp.enable("harper", true)
  vim.g.harper_enabled = true
end

--- Stop all harper LSP clients
local function stop_lsp()
  vim.lsp.enable("harper", false) -- Prevents auto-attaching to future buffers
  vim.g.harper_enabled = false
end

vim.keymap.set("n", "<Leader>dg", function()
  if vim.g.harper_enabled then
    stop_lsp()
    vim.notify "Harper LSP server disabled"
  else
    start_lsp()
    vim.notify "Harper LSP server enabled"
  end
end, { desc = "Toggle the grammar checker diagnostic messages on and off" })

-- Establish the initial state once Neovim has loaded and the Harper LSP is configured.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      vim.defer_fn(function() -- This delay should not be necessary but some directories seem to require it
        if not vim.g.harper_enabled then
          stop_lsp()
        end
      end, 100)
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
