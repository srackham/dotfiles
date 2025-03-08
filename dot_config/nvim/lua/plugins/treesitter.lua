return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      ensure_installed = {
        'bash',
        'c',
        'gleam',
        'go',
        'html',
        'javascript',
        'json',
        'jsonc',
        'lua',
        'markdown',
        'markdown_inline',
        'query',
        'rust',
        'typescript',
        'vim',
        'vimdoc',
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
