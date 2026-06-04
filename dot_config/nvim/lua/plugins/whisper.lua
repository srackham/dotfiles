return {
  "Avi-D-coder/whisper.nvim",
  config = function()
    require("whisper").setup {
      auto_download_model = false,
      model = "small.en",
      keybind = "<C-g>",
      manual_trigger_key = "<Space>",
      step_ms = 3000,
      length_ms = 5000,
    }
    -- Lualine integration
    require("lualine").setup {
      sections = {
        lualine_x = {
          require("whisper").lualine_component,
          "encoding",
          "fileformat",
          "filetype",
        },
      },
    }
  end,
  keys = {
    { "<C-g>", mode = { "n", "i", "v" }, desc = "Load the plugin" },
  },
}
