return {
  -- "srackham/qanda.nvim",
  dir = "/home/srackham/projects/qanda.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  enabled = true,
  config = function()

    local qanda = require "qanda"

    -- Override default options
    qanda.setup {
      -- model = "qwen3-coder:480b-cloud",
      -- model = "glm-5:cloud",
      model = "minimax-m2.5:cloud",
    }

    -- Custom key mappings
    vim.keymap.set({ "n", "v" }, "<Leader>lq", "<Cmd>Qanda /prompt<CR>", { desc = "Qanda.nvim open prompt (questions) window" })
    vim.keymap.set({ "n", "v" }, "<Leader>la", "<Cmd>Qanda /chat<CR>", { desc = "Qanda.nvim open chat (answers) window" })
    vim.keymap.set({ "n", "v" }, "<Leader>ln", "<Cmd>Qanda /new<CR>", { desc = "Qanda.nvim new chat" })
    vim.keymap.set({ "n", "v" }, "<Leader>lc", "<Cmd>Qanda /chats<CR>", { desc = "Qanda.nvim open chats picker" })
    vim.keymap.set({ "n", "v" }, "<Leader>lp", "<Cmd>Qanda /prompts<CR>", { desc = "Qanda.nvim open prompts picker" })
    vim.keymap.set({ "n", "v" }, "<leader>lm", "<Cmd>Qanda /models<CR>", { desc = "Qanda.nvim model selection" })
    vim.keymap.set({ "n", "v" }, "<leader>lv", "<Cmd>Qanda /providers<CR>", { desc = "Qanda.nvim provider selection" })
    vim.keymap.set({ "n", "v" }, "<leader>li", "<Cmd>Qanda /info<CR>", { desc = "Qanda.nvim info" })
    vim.keymap.set({ "n", "v" }, "<leader>l.", "<Cmd>Qanda .<CR>", { desc = "Qanda.nvim execute the previous prompt" })

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

    -- vim.keymap.set({ "n", "v" }, "<leader>ll", function()
    --   vim.cmd("edit " .. qanda.log_filename(qanda))
    -- end, { desc = "Qanda.nvim open current log file" })
    --
    -- vim.keymap.set({ "n", "v" }, "<Leader>lF", function()
    --   require("telescope.builtin").find_files {
    --     cwd = qanda.logs_dir,
    --     prompt_title = "Find log files",
    --   }
    -- end, { desc = "Qanda.nvim find log files" })
    --
    -- vim.keymap.set({ "n", "v" }, "<Leader>lG", function()
    --   require("telescope.builtin").live_grep {
    --     cwd = qanda.logs_dir,
    --     prompt_title = "Live Grep log files",
    --   }
    -- end, { desc = "Qanda.nvim live-grep log files" })

  end,
}
