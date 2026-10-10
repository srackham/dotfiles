require("vim._core.ui2").enable()

-- Yank, delete and change to the clipboard register
vim.opt.clipboard = "unnamedplus"

-- Normal mode: send all changes to the black-hole register so yanked text is not overwritten
vim.keymap.set("n", "c", '"_c', { noremap = true, silent = true })
vim.keymap.set("n", "cc", '"_cc', { noremap = true, silent = true })
vim.keymap.set("n", "C", '"_C', { noremap = true, silent = true })

-- Command-line completion
vim.opt.wildoptions = "pum"
vim.opt.wildmode = "longest:full,full"
vim.opt.wildmenu = true

-- Bootstrap lazy.nvim https://lazy.folke.io/installation
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set the following options before LazyVim setup is executed.
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
vim.g.editorconfig = false -- Disable .editorconfig files globally
vim.g.vim_init_file = vim.fn.stdpath "config" .. "/vim/init.vim"

vim.o.winborder = "single"

-- File types
vim.filetype.add {
  extension = {
    jsonl = "json",
  },
}

-- nvim-treesitter highlighting and indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "<filetype>" },
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Load abbreviations et al
vim.cmd("source " .. vim.g.vim_init_file)

-- Load and execute configuration files
require("lazy").setup "plugins"
require "options"
require "keymaps"
require "autocmds"
require "highlighting"
require "lsp_init"

-- Lastly load .nvimrc.lua file from root directory
local project_config_file = vim.fn.getcwd() .. "/.nvimrc.lua"
if vim.fn.filereadable(project_config_file) == 1 then
  vim.notify("Loading " .. project_config_file, vim.log.levels.INFO)
  local status_ok, err = pcall(dofile, project_config_file)
  if not status_ok then
    vim.notify("Error loading " .. project_config_file .. ": " .. err, vim.log.levels.ERROR)
  end
end

-- Colors (these should probably be moved to the catppuccin/nvim plugin
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) -- Use terminal's background
vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e2e" })

-- Spelling
vim.opt.spell = true
vim.opt.spelllang = { "en" }
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#ffcccb" })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#ffcccb" })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#ffcccb" })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#ffcccb" })
