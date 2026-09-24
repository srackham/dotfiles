return {
  -- "srackham/qanda.nvim",
  dir = "/home/srackham/projects/qanda.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  enabled = true,
  config = function()

    local qanda = require "qanda"

    -- Override default options here --
    qanda.setup {
      data_dir = "~/share/data/qanda_nvim",
      user_prompt_lines = 5,
      system_message_lines = 5,
      provider_options = {
        ollama = { temperature = 0.4 },
      },
    }

    -- Key mappings for builtin commands --
    vim.keymap.set({ "n", "v" }, "<C-Del>", "<Cmd>Qanda /new_prompt<CR>", { desc = "Open new prompt" })
    vim.keymap.set({ "n", "v" }, "<S-Tab>", "<Cmd>Qanda /chat_window<CR>", { desc = "Open user Chat window" })
    vim.keymap.set({ "n", "v" }, "<Leader>aa", "<Cmd>Qanda /repeat<CR>", { desc = "Execute previous command" })
    vim.keymap.set({ "n", "v" }, "<Leader>acd", "<Cmd>Qanda /delete_old_chats<CR>", { desc = "Delete old chats" })
    vim.keymap.set({ "n", "v" }, "<Leader>acl", "<Cmd>Qanda /toggle_chat_location<CR>", { desc = "Toggle Chat window location" })
    vim.keymap.set({ "n", "v" }, "<Leader>acn", "<Cmd>Qanda /new_chat<CR>", { desc = "New chat" })
    vim.keymap.set({ "n", "v" }, "<Leader>acp", "<Cmd>Qanda /chat_picker<CR>", { desc = "Open Chat picker" })
    vim.keymap.set({ "n", "v" }, "<Leader>acw", "<Cmd>Qanda /chat_window<CR>", { desc = "Open Chat window" })
    vim.keymap.set({ "n", "v" }, "<Leader>ade", "<Cmd>Qanda /diagnostics_enable<CR>", { desc = "Enable diagnostics capture" })
    vim.keymap.set({ "n", "v" }, "<Leader>add", "<Cmd>Qanda /diagnostics_disable<CR>", { desc = "Disable diagnostics capture" })
    vim.keymap.set({ "n", "v" }, "<Leader>adv", "<Cmd>Qanda /diagnostics_view<CR>", { desc = "Open diagnostics file" })
    vim.keymap.set({ "n", "v" }, "<Leader>ai", "<Cmd>Qanda /status<CR>", { desc = "Status information" })
    vim.keymap.set({ "n", "v" }, "<Leader>ak", "<Cmd>Qanda /abort<CR>", { desc = "Abort the current request" })
    vim.keymap.set({ "n", "v" }, "<Leader>amp", "<Cmd>Qanda /provider_picker<CR>", { desc = "Model provider selection" })
    vim.keymap.set({ "n", "v" }, "<Leader>amr", "<Cmd>Qanda /recent_models<CR>", { desc = "Recent model selection" })
    vim.keymap.set({ "n", "v" }, "<Leader>ams", "<Cmd>Qanda /model_picker<CR>", { desc = "Model selection" })
    vim.keymap.set({ "n", "v" }, "<Leader>apn", "<Cmd>Qanda /new_prompt<CR>", { desc = "Open new prompt" })
    vim.keymap.set({ "n", "v" }, "<Leader>apt", "<Cmd>Qanda /prompt_template_picker<CR>", { desc = "Open prompts template picker" })
    vim.keymap.set({ "n", "v" }, "<Leader>apw", "<Cmd>Qanda /prompt_window<CR>", { desc = "Open Prompt window" })
    vim.keymap.set({ "n", "v" }, "<Leader>ast", "<Cmd>Qanda /system_template_picker<CR>", { desc = "Open System template picker" })
    vim.keymap.set({ "n", "v" }, "<Leader>atp", "<Cmd>Qanda /turn_picker<CR>", { desc = "Open turn picker" })

    -- Key mappings for prompt templates --
    vim.keymap.set({ "n", "v" }, "<Leader>aq", ":Qanda !Query<CR>", { desc = "Ask a question" })
    -- English
    vim.keymap.set({ "n", "v" }, "<Leader>aea", ":Qanda !Antonyms<CR>", { desc = "Antonyms for a word" })
    vim.keymap.set({ "n", "v" }, "<Leader>aem", ":Qanda !Word meaning<CR>", { desc = "Word meaning" })
    vim.keymap.set({ "n", "v" }, "<Leader>aep", ":Qanda !Word pronunciation<CR>", { desc = "Word pronunciation" })
    vim.keymap.set({ "n", "v" }, "<Leader>aes", ":Qanda !Synonyms<CR>", { desc = "Synonyms for a word" })
    vim.keymap.set({ "n", "v" }, "<Leader>aew", ":Qanda !Spell a word<CR>", { desc = "Spell a word" })
    -- Latin
    vim.keymap.set({ "n", "v" }, "<Leader>alm", ":Qanda !Latin text meaning<CR>", { desc = "Latin text meaning" })
    vim.keymap.set({ "n", "v" }, "<Leader>alp", ":Qanda !Latin text pronunciation<CR>", { desc = "Latin text pronunciation" })
    -- Spanish
    vim.keymap.set({ "n", "v" }, "<Leader>asm", ":Qanda !Spanish text meaning<CR>", { desc = "Spanish text meaning" })
    vim.keymap.set({ "n", "v" }, "<Leader>asp", ":Qanda !Spanish text pronunciation<CR>", { desc = "Spanish text pronunciation" })

  end,
}
