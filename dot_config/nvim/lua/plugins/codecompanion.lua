return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "gemini",
          model = "gemini-2.5-flash"
        },
        inline = {
          adapter = "gemini",
          model = "gemini-2.5-flash"
        },
      },
      adapters = {
        http = {
          openrouter = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://openrouter.ai/api",
                api_key = "OPENROUTER_API_KEY",
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  -- Update this to your preferred default OpenRouter model ID
                  -- e.g., "anthropic/claude-3.5-sonnet", "google/gemini-2.0-flash-001"
                  default = "x-ai/grok-code-fast-1",
                },
              },
            })
          end,
        },
      },
      opts = {
        log_level = "DEBUG",
      },
      display = {
        chat = {
          window = {
            layout = "float",
            height = 0.8,
            width = 0.7,
          },
        },
      },
    })
    vim.keymap.set({ "n", "v" }, "ca", "<cmd>CodeCompanionActions<cr>",
      { noremap = true, silent = true, desc = "Open CodeCompanion Actions Palette" })
    vim.keymap.set({ "n", "v" }, "\\", require("codecompanion").toggle,
      { noremap = true, silent = true, desc = "Toggle CodeCompanion Chat window" })
    vim.cmd([[cab cc CodeCompanion]])
  end,
}
