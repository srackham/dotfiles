return {
  settings = {
    Lua = {
      diagnostics = {
        -- globals = { "vim", "Obsidian" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
}
