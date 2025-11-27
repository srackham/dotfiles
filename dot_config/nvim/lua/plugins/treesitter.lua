return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup {
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
        'toml',
        'vim',
        'vimdoc',
        'yaml',
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<M-k>",   -- Start selection
          node_incremental = "<M-k>", -- Expand to next node
          scope_incremental = false,  -- Expand by scope
          node_decremental = "<M-j>", -- Shrink selection
        },
      },
    }
  end
}
