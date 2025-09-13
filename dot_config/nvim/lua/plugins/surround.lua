return {
  'kylechui/nvim-surround',
  event = 'VeryLazy',
  config = function()
    require("nvim-surround").setup({
      surrounds = {
        -- Add Markdown bold surround
        ["b"] = {
          add = { "**", "**" },
          find = "%*%*.-%*%*",
          delete = "^(%*%*)().-(%*%*)()$",
        },
        -- Add Markdown underline surround
        ["u"] = {
          add = { "<u>", "</u>" },
          find = "<u>.-</u>",
          delete = "^(<u>)().-(</u>)()$",
        },
        -- Add Markdown strikethrough surround
        ["s"] = {
          add = { "~~", "~~" },
          find = "~~.-~~",
          delete = "^(~~)().-(~~)()$",
        },
      },
      aliases = {
        ["b"] = false,
        ["s"] = false,
        ["u"] = false,
        ["i"] = "_",  -- Markdown italics
        ["c"] = "`",  -- Markdown code
      },
    })
  end
}
