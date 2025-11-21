return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      chat = {
        adapter = "openrouter",
      },
      inline = {
        adapter = "openrouter",
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
                -- Update this to your preferred OpenRouter model ID
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
  },
}
