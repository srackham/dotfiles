return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT", -- Tell LuaLS we're on LuaJIT/5.1
      },
      format = {
        enable = false, -- Use external stylua command bound to <Leader>cf instead of the builtin lua_ls formatter
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
