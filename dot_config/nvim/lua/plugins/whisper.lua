local toggle_key = "<C-g>"
local trigger_key = "<Space>"

return {
  "Avi-D-coder/whisper.nvim",
  enabled = false,
  config = function()
    require("whisper").setup {
      auto_download_model = false,
      model = "small.en",
      keybind = toggle_key,
      manual_trigger_key = trigger_key,
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
    { toggle_key, mode = { "n", "i", "v" }, desc = "Load the plugin" },
  },
}
