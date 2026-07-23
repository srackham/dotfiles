return {
  cmd = { "harper-ls", "--stdio" },
  root_markers = { ".git" },

  -- 1. Add programming languages to allow comment checking
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

      -- 2. Downgrade severity to "hint" or "information" so warnings don't clutter your editor
      diagnosticSeverity = "hint",

      -- 3. Turn off overly strict style/grammar rules that cause noise
      linters = {
        spell_check = true,
        spelled_numbers = false, -- Stop complaining about "3" vs "three"
        long_sentences = false, -- Turning this off drastically reduces noise
        sentence_capitalization = true,
        repeated_words = true,
        spaces = true,
      },
    },
  },
}
