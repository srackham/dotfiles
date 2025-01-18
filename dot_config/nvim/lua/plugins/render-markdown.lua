return {
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {},
  config = function()
    local render_markdown = require('render-markdown')
    vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', { fg = '#7CA7FE', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH1', { fg = '#7CA7FE', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { bg = '#23273B' })
    vim.api.nvim_set_hl(0, '@markup.heading.2.markdown', { fg = '#D2AB72', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH2', { fg = '#D2AB72', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { bg = '#2D282C' })
    vim.api.nvim_set_hl(0, '@markup.heading.3.markdown', { fg = '#9FCB71', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH3', { fg = '#9FCB71', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { bg = '#252C2C' })
    vim.api.nvim_set_hl(0, '@markup.heading.4.markdown', { fg = '#19BC9C', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH4', { fg = '#19BC9C', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { bg = '#182931' })
    vim.api.nvim_set_hl(0, '@markup.heading.5.markdown', { fg = '#B89AF0', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH5', { fg = '#B89AF0', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { bg = '#29273A' })
    vim.api.nvim_set_hl(0, '@markup.heading.6.markdown', { fg = '#9B7DD4', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH6', { fg = '#9B7DD4', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH6Bg', { bg = '#262336' })
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
