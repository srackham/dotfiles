local util = require "lspconfig.util"

return {
  -- the root project directory for this language server will be determined by the presence
  -- of either a deno.json or deno.jsonc file somewhere up the directory tree from the current file.
  root_dir = util.root_pattern("deno.json", "deno.jsonc"),
}
