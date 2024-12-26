return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup({
      toggler = {
        line = '<C-_>',  -- Line-comment toggle keymap
        block = '<A-/>', -- Block-comment toggle keymap
      },
      opleader = {
        line = '<C-_>',  -- Line-comment keymap
        block = '<A-/>', -- Block-comment keymap
      },
    })
  end,
}
