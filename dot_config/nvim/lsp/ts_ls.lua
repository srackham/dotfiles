return {
  root_dir = function(bufnr, on_dir)
    -- Exclude Deno projects
    if vim.fs.root(bufnr, { "deno.json", "deno.jsonc" }) then
      return
    end
    local root = vim.fs.root(bufnr, { "package.json", "tsconfig.json" })
    if root then
      on_dir(root)
    end
  end,
}
