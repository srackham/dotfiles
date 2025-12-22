local util = require "lspconfig.util"

return {
  -- If the project has a deno.json or deno.jsonc file in the hierarchy, the function returns nil.
  -- This excludes tsserver activation in Deno projects and avoids conflicts with Deno's own language server.
  root_dir = function(fname)
    if util.root_pattern("deno.json", "deno.jsonc")(fname) then
      return nil -- exclude tsserver in Deno projects
    else
      return util.root_pattern "package.json"(fname)
    end
  end,
  single_file_support = false,
}
