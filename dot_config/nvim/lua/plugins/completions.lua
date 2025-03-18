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
    'hrsh7th/cmp-buffer',
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
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
        })
      })
      -- Restrict sources for specific file types
      cmp.setup.filetype('markdown', {
        sources = {
          { name = 'luasnip' },
        },
      })
      -- Toggle completion for current buffer
      vim.keymap.set('n', '<Leader>oc', function()
        local is_enabled = not cmp.get_config().enabled
        cmp.setup.buffer { enabled = is_enabled }
        vim.notify(is_enabled and "Auto-completion enabled" or "Auto-completion disabled")
      end, { noremap = true, silent = true, desc = "Toggle auto-completion" })
      -- Disable completion for text files by default
      vim.api.nvim_create_autocmd({ 'FileType' }, {
        pattern = { 'text' },
        callback = function()
          cmp.setup.buffer { enabled = false }
        end
      })
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
      vim.keymap.set('n', '<Leader>os', require("luasnip.loaders").edit_snippet_files,
        { noremap = true, desc = "Edit snippets" })
    end,
  },
}
