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
      diagnosticSeverity = "hint",

      -- Turn off overly strict style/grammar rules that cause noise
      linters = {
        spell_check = false,
        spelled_numbers = false, -- Stop complaining about "3" vs "three"
        long_sentences = false,
        sentence_capitalization = false,
        repeated_words = true,
        spaces = true,
      },
    },
  },
}
