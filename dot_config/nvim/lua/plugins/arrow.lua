return {
  "otavioschwanck/arrow.nvim",
  enabled = false,
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  opts = {
    show_icons = true,
    leader_key = "B", -- File bookmarks
    buffer_leader_key = "M", -- Buffer bookmarks
    separate_save_and_remove = false,
    mappings = {
      toggle = "M",
    },
  },
}
