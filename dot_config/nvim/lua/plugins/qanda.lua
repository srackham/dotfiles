return {
  -- "srackham/qanda.nvim",
  dir = "/home/srackham/projects/qanda.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  enabled = true,
  config = function()

    local qanda = require "qanda"

    -- Override default options --
    qanda.setup {
      data_dir = "~/projects/qanda.nvim/data",
      chat_reload = true,
      user_prompt_lines = 5,
      system_prompt_lines = 5,
      model_options = {
        ollama = { temperature = 0.4 },
        openrouter = {},
      },
      confirm_chat_file_deletion = false,
    }

    -- Key mappings for builtin commands --
    vim.keymap.set("n", "<Tab>", "<Cmd>Qanda /prompt_window<CR>", { desc = "Qanda.nvim open user prompt window (questions)" })
    vim.keymap.set({ "n", "v" }, "<Leader>lq", "<Cmd>Qanda /prompt_window<CR>", { desc = "Qanda.nvim open user prompt window (questions)" })
    vim.keymap.set({ "n", "v" }, "<Leader>lp", "<Cmd>Qanda /prompt_picker<CR>", { desc = "Qanda.nvim open user prompts picker" })
    vim.keymap.set({ "n", "v" }, "<Leader>la", "<Cmd>Qanda /chat_window<CR>", { desc = "Qanda.nvim open chat window (answers)" })
    vim.keymap.set({ "n", "v" }, "<Leader>lc", "<Cmd>Qanda /chat_picker<CR>", { desc = "Qanda.nvim open chat picker" })
    vim.keymap.set({ "n", "v" }, "<Leader>ln", "<Cmd>Qanda /new_chat<CR>", { desc = "Qanda.nvim new chat" })
    vim.keymap.set({ "n", "v" }, "<Leader>ls", "<Cmd>Qanda /system_message_picker<CR>", { desc = "Qanda.nvim open system messages picker" })
    vim.keymap.set({ "n", "v" }, "<leader>lm", "<Cmd>Qanda /models<CR>", { desc = "Qanda.nvim model selection" })
    vim.keymap.set({ "n", "v" }, "<leader>lP", "<Cmd>Qanda /providers<CR>", { desc = "Qanda.nvim provider selection" })
    vim.keymap.set({ "n", "v" }, "<leader>li", "<Cmd>Qanda /status<CR>", { desc = "Qanda.nvim status information" })
    vim.keymap.set(
      { "n", "v" },
      "<leader>lr",
      "<Cmd>Qanda /dump_diagnostics<CR>",
      { desc = "Qanda.nvim insert request and response registers" }
    )
    vim.keymap.set({ "n", "v" }, "<leader>lt", "<Cmd>Qanda /turn_picker<CR>", { desc = "Qanda.nvim open turn picker" })

    -- Key mappings for custom prompts --
    vim.keymap.set({ "n", "v" }, "<Leader>lQ", "<Cmd>Qanda Ask a question<CR>", { desc = "Qanda.nvim ask a question" })
    vim.keymap.set({ "n", "v" }, "<Leader>lD", "<Cmd>Qanda Dictionary definition<CR>", { desc = "Qanda.nvim dictionary definition" })
    vim.keymap.set({ "n", "v" }, "<Leader>lL", "<Cmd>Qanda Latin word morphology<CR>", { desc = "Qanda.nvim Latin word morphology" })
    vim.keymap.set({ "n", "v" }, "<Leader>lS", "<Cmd>Qanda Synonyms<CR>", { desc = "Qanda.nvim Latin word morphology" })

    vim.keymap.set("n", "<Leader>lo", 'o<Esc>"' .. qanda.Config.response_register .. "p", {
      desc = "Open line below and paste the model response",
    })
    vim.keymap.set("n", "<Leader>lO", 'O<Esc>"' .. qanda.Config.response_register .. "p", {
      desc = "Open line above and paste the model response",
    })

    vim.keymap.set({ "n", "v" }, "<Leader>lf", function()
      require("telescope.builtin").find_files {
        cwd = qanda.prompts_dir,
        prompt_title = "Find prompts files",
      }
    end, { desc = "Qanda.nvim find prompts files" })

    vim.keymap.set({ "n", "v" }, "<Leader>lg", function()
      require("telescope.builtin").live_grep {
        cwd = qanda.Config.prompts_dir,
        prompt_title = "Live Grep prompts files",
      }
    end, { desc = "Qanda.nvim live-grep prompts files" })

  end,
}
