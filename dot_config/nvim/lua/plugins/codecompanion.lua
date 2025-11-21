return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    -- Custom model selector based on code from https://github.com/olimorris/codecompanion.nvim/discussions/1013#discussioncomment-12735567

    local default_model = "x-ai/grok-code-fast-1"
    local available_models = {
      "x-ai/grok-code-fast-1",
      "qwen/qwen3-coder-30b-a3b-instruct",
      "anthropic/claude-3.7-sonnet",
      "anthropic/claude-3.5-sonnet",
      "openai/gpt-4o-mini",
    }
    local current_model = default_model

    local function select_model()
      vim.ui.select(available_models, {
        prompt = "Select  Model:",
      }, function(choice)
        if choice then
          current_model = choice
          vim.notify("Selected model: " .. current_model)
        end
      end)
    end

    require("codecompanion").setup({
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
                  default = current_model,
                },
              },
            })
          end,
        },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "cc", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>co", select_model, { desc = "Select OpenRouter model" })
    vim.cmd([[cab cc CodeCompanion]]) -- Expand 'cc' into 'CodeCompanion' in the command line
  end,

}
