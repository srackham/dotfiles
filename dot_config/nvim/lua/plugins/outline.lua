return {
  "hedyhli/outline.nvim",
  config = function()
    require("outline").setup {
      -- Your setup opts here (leave empty to use defaults)
      keymaps = {
        up_and_jump = "<C-p>",
        down_and_jump = "<C-n>",
      },
      symbol_folding = {
        -- Depth past which nodes will be folded by default. Set to false to unfold all on open.
        autofold_depth = 1,
      },
      outline_window = {
        position = "right",
        width = 40,
        relative_width = false,
      },
    }

    -- Key mappings
    local function outline_is_open()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "Outline" then
          return true
        end
      end
      return false
    end
    local function toggle_focus()
      if outline_is_open() then
        vim.cmd "OutlineFocus"
      else
        vim.cmd "OutlineOpen"
      end
    end
    vim.keymap.set("n", "<Leader>eo", toggle_focus, { desc = "Toggle outline focus" })

    -- Map "O" to "o<Esc>" in outline window to open location and close outline
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "Outline",
      callback = function()
        vim.keymap.set("n", "O", "o<Esc>", { buffer = true, remap = true })
      end,
    })
  end,
}
