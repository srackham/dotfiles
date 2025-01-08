return {
  'catppuccin/nvim',
  lazy = false,
  name = 'catppuccin',
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = 'auto',    -- latte, frappe, macchiato, mocha
      no_underline = true, -- Force no underline
      no_bold = true,      -- Force no underline
      color_overrides = {
        all = {
          base = '#1c1c1c',
        },
      },
    })
    -- setup must be called before loading
    vim.cmd.colorscheme 'catppuccin'

    -- Color scheme tweaks
    vim.api.nvim_set_hl(0, 'Comment', { fg = '#aaaaaa' }) -- Comments group color
    vim.api.nvim_set_hl(0, 'LineNr', { fg = 'gray' })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = 'white' })
  end,
}
