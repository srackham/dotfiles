return {
  cmd = { "harper-ls", "--stdio" },
  root_markers = { ".git" },

  filetypes = {
    "markdown",
    "text",
    "typst",
    "tex",
    "lua",
    "python",
    "rust",
    "go",
    "javascript",
    "typescript",
    "c",
    "cpp",
  },

  settings = {
    ["harper-ls"] = {
      userDictPath = "~/.config/harper/dict.txt",
      diagnosticSeverity = "hint",

      linters = { -- See https://writewithharper.com/docs/rules
        SpellCheck = false,
        SpelledNumbers = false,
        AnA = true,
        LongSentences = false,
        SentenceCapitalization = true,
        RepeatedWords = true,
        Spaces = true,
        UseTitleCase = false,
      },
    },
  },
}
