return {
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {},
  config = function()
    local render_markdown = require('render-markdown')
    render_markdown.setup({
      -- sign = { enabled = false },
      html = {
        comment = {
          conceal = true,
          text = '▶️',
          highlight = 'RenderMarkdownH3',
        },
      },
      heading = {
        position = 'inline',
      },
    })
    vim.keymap.set('n', '<Leader>mt', render_markdown.toggle, { desc = "Toggle Render Markdown" })
  end,
}
