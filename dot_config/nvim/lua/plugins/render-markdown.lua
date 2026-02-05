return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {},
  config = function()
    local render_markdown = require "render-markdown"
    local header_colors = {
      -- { "#FFA500", "#2B1E00" },
      { "#FAB387", "#2D1D13" },
      { "#F9E2AF", "#28241A" },
      { "#F5C2E7", "#271B24" },
      { "#B89AF0", "#1D1A2B" },
      { "#9B7DD4", "#191524" },
    }
    for i = 1, 6 do
      local fg, bg = header_colors[math.min(i, #header_colors)][1], header_colors[math.min(i, #header_colors)][2]
      vim.api.nvim_set_hl(0, "@markup.heading." .. i .. ".markdown", { fg = fg, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, { fg = fg, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", { bg = bg })
    end
    vim.api.nvim_set_hl(0, "@markup.quote", { fg = "#b4befe" })
    vim.api.nvim_set_hl(0, "RenderMarkdownQuote", { fg = "#b4befe" })
    render_markdown.setup {
      code = {
        sign = false,
      },
      html = {
        comment = {
          conceal = false,
          text = "▶️",
          highlight = "RenderMarkdownH3",
        },
      },
      heading = {
        enabled = false, -- Disable so that marks.nvim marks are visible in left margin of headings
        position = "inline",
        width = { "full", "full", "block", "block", "block", "block" },
        border = { true, true, false, false, false, false },
      },
    }
    vim.keymap.set("n", "<Leader>mt", render_markdown.toggle, { desc = "Toggle Render Markdown" })
  end,
}
