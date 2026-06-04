return {
  "Avi-D-coder/whisper.nvim",
  config = function()
    require("whisper").setup {
      auto_download_model = false,
      model = "base.en",
      keybind = "<C-g>",
      manual_trigger_key = "<Space>",
    }
  end,
  keys = {
    { "<C-g>", mode = { "n", "i", "v" }, desc = "Load the plugin" },
  },
}
