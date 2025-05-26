return {

  -- Install completion source plugins
  {
    "hrsh7th/cmp-nvim-lsp",
    enabled = false,
  },
  {
    "hrsh7th/cmp-buffer",
    enabled = false,
  },
  {
    "L3MON4D3/LuaSnip",
    enabled = false,
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },

  -- Install completion engine
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    dependencies = {
      "hrsh7th/nvim-lspconfig", -- Ensure nvim_lspconfig is installed and loaded first
    },
    config = function()
      local cmp = require "cmp"
      local snippets_dir = vim.fn.stdpath("config") .. "/lua/snippets"
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = snippets_dir })
      require("luasnip.loaders.from_lua").lazy_load({ paths = snippets_dir })
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ["<c-d>"] = cmp.mapping.scroll_docs(-4),
          ["<c-f>"] = cmp.mapping.scroll_docs(4),
          ["<c-space>"] = cmp.mapping.complete(),
          ["<cr>"] = cmp.mapping.confirm({ select = true }),
        }),

        -- Ordered by sources declaration order
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer",  keyword_length = 3 },
        })
      })

      -- Toggle completion for current buffer
      vim.keymap.set("n", "<leader>ct", function()
        local is_enabled = not cmp.get_config().enabled
        cmp.setup.buffer { enabled = is_enabled }
        vim.notify(is_enabled and "Auto-completion enabled" or "Auto-completion disabled")
      end, { noremap = true, silent = true, desc = "Toggle auto-completion" })

      -- LuaSnip key mappings
      local luasnip = require("luasnip")
      vim.keymap.set({ "i", "s" }, "<c-j>", function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { desc = "Expand snippet or jump to snippet next field", silent = true })
      vim.keymap.set({ "i", "s" }, "<c-m-j>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { desc = "Jump to previous snippet field", silent = true })
      vim.keymap.set("n", "<leader>es", require("luasnip.loaders").edit_snippet_files,
        { noremap = true, desc = "Edit snippets" })
    end,
  },
}
