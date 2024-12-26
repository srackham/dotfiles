return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup({
      toggler = {
        line = '<C-_>',
        block = '<A-/>',
      },
      opleader = {
        line = '<C-_>',
        block = '<A-/>',
      },
    })
  end,
}
