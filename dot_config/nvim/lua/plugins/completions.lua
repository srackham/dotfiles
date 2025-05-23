return {
  {
    -- Completions won't work without pulling this in despite having its own plugin config file
    'hrsh7th/nvim-lspconfig',
  },
  {
    'hrsh7th/cmp-nvim-lsp',
  },
  {
    'hrsh7th/cmp-buffer',
  },
  {
    'hrsh7th/cmp-path',
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
      local snippets_dir = vim.fn.stdpath('config') .. '/lua/snippets'
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load({ paths = snippets_dir })
      require('luasnip.loaders.from_lua').lazy_load({ paths = snippets_dir })
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
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),

        -- Ordered by priority
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer',  keyword_length = 3 },
        })
      })

      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })

      -- 24-May-2025: TODO: drop unused code
      -- -- Restrict sources for specific file types
      -- cmp.setup.filetype('markdown', {
      --   sources = {
      --     { name = 'luasnip' },
      --   },
      -- })

      -- 24-May-2025: TODO: drop unused code
      -- -- Disable completion for text files by default
      -- vim.api.nvim_create_autocmd({ 'FileType' }, {
      --   pattern = { "markdown", "text" },
      --   callback = function()
      --     cmp.setup.buffer { enabled = false }
      --   end
      -- })

      -- Toggle completion for current buffer
      vim.keymap.set('n', '<Leader>ct', function()
        local is_enabled = not cmp.get_config().enabled
        cmp.setup.buffer { enabled = is_enabled }
        vim.notify(is_enabled and "Auto-completion enabled" or "Auto-completion disabled")
      end, { noremap = true, silent = true, desc = "Toggle auto-completion" })

      -- LuaSnip key mappings
      local luasnip = require('luasnip')
      vim.keymap.set({ 'i', 's' }, '<C-j>', function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { desc = "Expand snippet or jump to snippet next field", silent = true })
      vim.keymap.set({ 'i', 's' }, '<C-M-j>', function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { desc = "Jump to previous snippet field", silent = true })
      vim.keymap.set('n', '<Leader>es', require("luasnip.loaders").edit_snippet_files,
        { noremap = true, desc = "Edit snippets" })
    end,
  },
}
