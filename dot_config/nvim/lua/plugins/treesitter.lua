return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      ensure_installed = {
        'bash', 'c', 'lua', 'vim', 'vimdoc', 'query', 'go', 'gleam', 'javascript', 'html', 'rust', 'typescript'
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
