return {
  {
    'hrsh7th/cmp-nvim-lsp',
  },
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    }
  },
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require 'cmp'
      require('luasnip.loaders.from_vscode').lazy_load()
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
      local cmp_enabled = true
      vim.keymap.set('n', '<Leader>at', function()
        cmp_enabled = not cmp_enabled
        cmp.setup { enabled = cmp_enabled }
        vim.notify(cmp_enabled and 'Auto-completion enabled' or 'Auto-completion disabled', vim.log.levels.INFO)
      end, { noremap = true, silent = true, desc = 'Toggle auto-completion' })
    end,
  },
}