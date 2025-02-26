-- This file lazily loaded into markdown buffers i.e. it is loaded when the first markdown buffer is opened.

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require 'luasnip.extras'
local rep = extras.rep

local snippets = {
  s('hello-markdown', {
    t("Hello Markdown!"),
  }),
  s({
    trig = 'u',
    name = 'URL',
    desc = 'Add URL wrapped in a Markdown link',
    priority = 1001, -- Default snippet priority is 1000
  }, {
    t('['), rep(1), t(']('), i(1), t(')'), i(0),
  }),
}

-- Append Obsidian callout snippets.
local callout_types = {
  { trig = 'abstract',  name = 'ABSTRACT',  desc = "Abstract or summary" },
  { trig = 'attention', name = 'ATTENTION', desc = "Important information" },
  { trig = 'bug',       name = 'BUG',       desc = "Bug or error" },
  { trig = 'check',     name = 'CHECK',     desc = "Verification needed" },
  { trig = 'cite',      name = 'CITE',      desc = "Citation or reference" },
  { trig = 'danger',    name = 'DANGER',    desc = "Dangerous situation or warning" },
  { trig = 'done',      name = 'DONE',      desc = "Completed task" },
  { trig = 'error',     name = 'ERROR',     desc = "Error message or description" },
  { trig = 'example',   name = 'EXAMPLE',   desc = "Illustrative example" },
  { trig = 'fail',      name = 'FAIL',      desc = "Failure scenario" },
  { trig = 'failure',   name = 'FAILURE',   desc = "Failure description" },
  { trig = 'faq',       name = 'FAQ',       desc = "Frequently asked question" },
  { trig = 'help',      name = 'HELP',      desc = "Help or assistance needed" },
  { trig = 'hint',      name = 'HINT',      desc = "Helpful hint" },
  { trig = 'info',      name = 'INFO',      desc = "Additional information" },
  { trig = 'missing',   name = 'MISSING',   desc = "Missing information or component" },
  { trig = 'question',  name = 'QUESTION',  desc = "Question to be addressed" },
  { trig = 'quote',     name = 'QUOTE',     desc = "Quotation" },
  { trig = 'success',   name = 'SUCCESS',   desc = "Successful outcome" },
  { trig = 'summary',   name = 'SUMMARY',   desc = "Brief summary" },
  { trig = 'tldr',      name = 'TLDR',      desc = "Too long; didn't read" },
  { trig = 'todo',      name = 'TODO',      desc = "Task to be done" }
}

for _, callout in ipairs(callout_types) do
  table.insert(snippets,
    s({
      trig = callout.trig,
      name = callout.name,
      desc = callout.desc
    }, {
      t('> [!' .. callout.name .. ']'),
      t({ '', '> ' })
    })
  )
end

return snippets
