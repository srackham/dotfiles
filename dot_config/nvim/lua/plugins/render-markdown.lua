return {
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {},
  config = function()
    local render_markdown = require('render-markdown')


    local header_colors = {
      { '#7CA7FE', '#23273B' },
      { '#D2AB72', '#2D282C' },
      { '#9FCB71', '#252C2C' },
      { '#19BC9C', '#182931' },
      { '#B89AF0', '#29273A' },
      { '#9B7DD4', '#262336' },
    }
    for i = 1, 6 do
      local fg, bg = header_colors[math.min(i, #header_colors)][1], header_colors[math.min(i, #header_colors)][2]
      vim.api.nvim_set_hl(0, '@markup.heading.' .. i .. '.markdown', { fg = fg, bold = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. i, { fg = fg, bold = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. i .. 'Bg', { bg = bg })
    end
    render_markdown.setup({
      html = {
        comment = {
          conceal = true,
          text = '▶️',
          highlight = 'RenderMarkdownH3',
        },
      },
      heading = {
        position = 'inline',
        width = { 'full', 'full', 'block', 'block', 'block', 'block' },
        border = { true, false, false, false, false, false },
      },
    })
    vim.keymap.set('n', '<Leader>M', render_markdown.toggle, { desc = "Toggle Render Markdown" })
  end,
}
