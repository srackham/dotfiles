return {
  -- https://github.com/catppuccin/nvim
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "auto",    -- latte, frappe, macchiato, mocha
      no_underline = true, -- Force no underline
      no_bold = true,      -- Force no underline
    })
    -- setup must be called before loading
    vim.cmd.colorscheme "catppuccin"
  end,
}
