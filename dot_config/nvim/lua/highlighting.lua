vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = '*',
  callback = function()
    -- BUG: 22-Feb-2025: These definitions do not highlight inside quote blocks and I don't want to waste time trying to fix it.
    --      25-Feb-2025: I spent hours on this to no avail; neither Perplexity.ai, Gemini or ChatGPT was able to solve it.
    -- Colon-suffixed key words
    vim.cmd('syntax match HighlightText-1 /\\<\\(FIXME\\|TODO\\):/')
    vim.api.nvim_set_hl(0, 'HighlightText-1', { bg = 'red', fg = '#ffd700', bold = true })
    vim.cmd('syntax match HighlightText-2 /\\<NOTE:/')
    vim.api.nvim_set_hl(0, 'HighlightText-2', { fg = '#ff7f50', bold = true })
    vim.cmd('syntax match HighlightText-3 /\\<TIP:/')
    vim.api.nvim_set_hl(0, 'HighlightText-3', { fg = '#3cb371', bold = true })
    vim.cmd('syntax match HighlightText-4 /\\<TLDR:/')
    vim.api.nvim_set_hl(0, 'HighlightText-4', { fg = 'yellow', bold = true })
    vim.cmd('syntax match HighlightText-5 /\\<\\(DRAFT\\|IMPORTANT\\|UPDATE\\|WARNING\\):/')
    vim.api.nvim_set_hl(0, 'HighlightText-5', { fg = '#ff1493', bold = true })
    vim.cmd('syntax match HighlightText-6 /\\<\\(ATTENTION\\|BUG\\|DEPRECATED\\|DONE\\|???\\|!!!.\\+!!!\\):/')
    vim.cmd('syntax match HighlightText-6 /???\\|!!!.\\+!!!/')
    vim.api.nvim_set_hl(0, 'HighlightText-6', { fg = 'red', bold = true })
    -- Raw HTTP links
    vim.cmd([[syntax match @markup.link.label 'https\?://\S\+[^).]']])
  end
})
