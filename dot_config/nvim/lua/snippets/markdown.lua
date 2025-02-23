-- This file lazily loaded into markdown buffers i.e. it is loaded when the first markdown buffer is opened.

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node

return {
  s('hello-markdown', {
    t("Hello Markdown!"),
  }),
  s({
    trig = "tldr",
    name = "TLDR",
    desc = "To long; didn't read"
  }, {
    t("> [!TLDR]"),
    t({ "", "> " }),
  }),
}
