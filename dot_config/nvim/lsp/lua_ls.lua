return {
  settings = {
    Lua = {
      format = {
        enable = true, -- Enable builtin lua_ls formatter
      },
      diagnostics = {
        -- globals = { "vim", "Obsidian" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
}
