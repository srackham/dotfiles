-- Auto-save on focus lost
vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  command = "silent! wa",
  nested = true,
})

-- Disable automatic line comment insertion for all filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    vim.cmd "set formatoptions-=ro"
  end,
})

-- Text files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "asciidoc", "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
    -- Soft-wrapped line navigation for markdown and text files
    vim.keymap.set("n", "j", "gj", { buffer = true })
    vim.keymap.set("n", "k", "gk", { buffer = true })
    vim.keymap.set("n", "0", "g0", { buffer = true })
    vim.keymap.set("n", "$", "g$", { buffer = true })
  end,
})

-- Highlight text on yank
-- Create an augroup to avoid duplicate autocmds on reload
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_group,
  callback = function()
    vim.highlight.on_yank { higroup = "Search", timeout = 500 }
  end,
})

-- Auto-save Rust source files after a period of inactivity
-- FIXME: This is a kludge because I can't figure how to force the Rust LSP to do lint check without saving.
local timer = vim.loop.new_timer()
local save_delay = 500

local function auto_save()
  if vim.api.nvim_get_mode().mode == "n" and vim.bo.modifiable and not vim.bo.readonly then
    vim.cmd "silent update"
  end
end

local function reset_timer()
  timer:stop()
  timer:start(save_delay, 0, vim.schedule_wrap(auto_save))
end

-- Start/reset timer on InsertLeave and TextChanged events (simulate inactivity)
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*.rs",
  callback = reset_timer,
})

-- Stop timer on InsertEnter (user is active)
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*.rs",
  callback = function()
    timer:stop()
  end,
})
