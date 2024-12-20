vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*",
  callback = function()
    vim.cmd("syntax match HighlightText-1 /\\<\\(FIXME\\|TODO\\):/")
    vim.api.nvim_set_hl(0, "HighlightText-1", { bg = "red", fg = "#ffd700", bold = true })
    vim.cmd("syntax match HighlightText-2 /\\<NOTE:/")
    vim.api.nvim_set_hl(0, "HighlightText-2", { fg = "#ff7f50", bold = true })
    vim.cmd("syntax match HighlightText-3 /\\<TIP:/")
    vim.api.nvim_set_hl(0, "HighlightText-3", { fg = "#3cb371", bold = true })
    vim.cmd("syntax match HighlightText-4 /\\<TLDR:/")
    vim.api.nvim_set_hl(0, "HighlightText-4", { fg = "yellow", bold = true })
    vim.cmd("syntax match HighlightText-5 /\\(\\<DRAFT\\|\\<IMPORTANT:\\|\\<UPDATE:\\|\\<WARNING:\\)/")
    vim.api.nvim_set_hl(0, "HighlightText-5", { fg = "#ff1493", bold = true })
    vim.cmd("syntax match HighlightText-6 /\\(\\<ATTENTION:\\|\\<BUG:\\|\\<DEPRECATED:\\|\\<DONE:\\|???\\|!!!.\\+!!!\\)/")
    vim.api.nvim_set_hl(0, "HighlightText-6", { fg = "red", bold = true })
  end
})
