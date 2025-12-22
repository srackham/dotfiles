--[[

# Completions and snippets plugin configurations file

## Snippets
Aside from the `friendly-snippets` dependency there's nothing to set up.

Blink uses the `vim.snippet` API by default for expanding and navigating snippets. The built-in
`snippets` source will load [friendly-snippets](https://github.com/rafamadriz/friendly-snippets), if
available, and load any snippets found at `~/.config/nvim/snippets/`.

By default, the snippets source will check ~/.config/nvim/snippets for your custom snippets, but you
may add additional folders via sources.providers.snippets.opts.search_paths. Currently, only VSCode
style snippets are supported, but you may look into Luasnip if you'd like more advanced
functionality.

See:

- https://cmp.saghen.dev/configuration/snippets.html

]]

return {
  -- Completion engine: blink.cmp
  {
    "saghen/blink.cmp",
    version = "1.*", -- Use a release tag to download pre-built binaries

    dependencies = {
      "rafamadriz/friendly-snippets",
    },

    -- See https://cmp.saghen.dev/installation.html for options
    config = function()
      local cmp = require "blink.cmp"
      local cmp_enabled = true

      cmp.setup {
        keymap = {
          preset = "default",
          ["<C-Space>"] = { "select_and_accept" },
        },
        appearance = {
          nerd_font_variant = "mono",
        },
        completion = {
          menu = {
            border = "single",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          },
          documentation = {
            auto_show = true,
            window = {
              border = "single",
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
            },
          },
        },
        cmdline = { enabled = false },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          providers = {
            snippets = {
              min_keyword_length = 2,
              score_offset = 4,
            },
            lsp = {
              min_keyword_length = 3,
              score_offset = 3,
            },
            path = {
              min_keyword_length = 3,
              score_offset = 2,
            },
            buffer = {
              min_keyword_length = 5,
              score_offset = 1,
            },
          },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        enabled = function()
          return cmp_enabled
        end,
      }

      local function toggle_completions()
        cmp_enabled = not cmp_enabled
        vim.notify("Completions " .. (cmp_enabled and "enabled" or "disabled"))
      end
      vim.keymap.set("n", "<leader>ct", toggle_completions, { noremap = true, silent = true, desc = "Toggle completions" })
    end,

    opts_extend = { "sources.default" },
  },
}
