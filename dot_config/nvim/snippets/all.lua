-- Because this file is named `all.lua` it is unconditionally loaded by the Luasnip Lua loader.

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node

return {
  -- Available in all buffers
  s('example-lua-4', {
    t("Hello All!"),
  }),
  -- Available in markdown buffers
  s({ filetype = 'markdown', trig = 'example-lua-5' }, {
    t("Hello All Markdown!"),
  }),
}
