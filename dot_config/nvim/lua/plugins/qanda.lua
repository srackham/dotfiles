return {
  -- "srackham/qanda.nvim",
  dir = "/home/srackham/projects/qanda.nvim",
  enabled = true,
  config = function()

    local qanda = require "qanda"

    -- Override default options
    qanda.setup {
      -- model = "qwen3-coder:480b-cloud",
      -- model = "glm-4.7:cloud",
      model = "minimax-m2.1:cloud",
    }

    -- Custom key mappings
    vim.keymap.set({ "n", "v" }, "<Leader>zq", "<Cmd>Qanda /prompt<CR>", { desc = "Qanda.nvim open prompt (questions) window" })
    vim.keymap.set({ "n", "v" }, "<Leader>za", "<Cmd>Qanda /chat<CR>", { desc = "Qanda.nvim open chat (answers) window" })
    vim.keymap.set({ "n", "v" }, "<Leader>zn", "<Cmd>Qanda /new<CR>", { desc = "Qanda.nvim new chat" })
    vim.keymap.set({ "n", "v" }, "<Leader>zc", "<Cmd>Qanda /chats<CR>", { desc = "Qanda.nvim open chats picker" })
    vim.keymap.set({ "n", "v" }, "<Leader>zp", "<Cmd>Qanda /prompts<CR>", { desc = "Qanda.nvim open prompts picker" })
    vim.keymap.set({ "n", "v" }, "<leader>zm", "<Cmd>Qanda /models<CR>", { desc = "Qanda.nvim model selection" })
    vim.keymap.set({ "n", "v" }, "<leader>zv", "<Cmd>Qanda /providers<CR>", { desc = "Qanda.nvim provider selection" })
    vim.keymap.set({ "n", "v" }, "<leader>z.", "<Cmd>Qanda .<CR>", { desc = "Qanda.nvim repeat previous command" })

    vim.keymap.set({ "n", "v" }, "<Leader>zf", function()
      require("telescope.builtin").find_files {
        cwd = qanda.prompts_dir,
        prompt_title = "Find prompts files",
      }
    end, { desc = "Qanda.nvim find prompts files" })

    vim.keymap.set({ "n", "v" }, "<Leader>zg", function()
      require("telescope.builtin").live_grep {
        cwd = qanda.prompts_dir,
        prompt_title = "Live Grep prompts files",
      }
    end, { desc = "Qanda.nvim live-grep prompts files" })

    -- vim.keymap.set({ "n", "v" }, "<leader>zl", function()
    --   vim.cmd("edit " .. qanda.log_filename(qanda))
    -- end, { desc = "Qanda.nvim open current log file" })
    --
    -- vim.keymap.set({ "n", "v" }, "<Leader>zF", function()
    --   require("telescope.builtin").find_files {
    --     cwd = qanda.logs_dir,
    --     prompt_title = "Find log files",
    --   }
    -- end, { desc = "Qanda.nvim find log files" })
    --
    -- vim.keymap.set({ "n", "v" }, "<Leader>zG", function()
    --   require("telescope.builtin").live_grep {
    --     cwd = qanda.logs_dir,
    --     prompt_title = "Live Grep log files",
    --   }
    -- end, { desc = "Qanda.nvim live-grep log files" })

  end,
}
