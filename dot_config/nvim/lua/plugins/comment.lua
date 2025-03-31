return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup({
      toggler = {
        line = '<C-_>',
        block = '<M-/>',
      },
      opleader = {
        line = '<C-_>',
        block = '<M-/>',
      },
    })
  end,
}
