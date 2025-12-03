return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup({
      -- Non-default configuration
      toggler = {
        block = 'gCC', ---Block-comment toggle keymap
      },
      opleader = {
        block = 'gC', ---Block-comment keymap
      },
    })
  end,
}
