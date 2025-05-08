-- Bootstrap lazy.nvim https://lazy.folke.io/installation
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out,                            'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- The following options must be set before LazyVim setup is executed.
vim.g.mapleader = ','
vim.g.maplocalleader = '\\'

Utils = require 'utils'          -- Load ./lua/utils.lua
require('lazy').setup('plugins') -- Load ./lua/plugins/*.lua
require 'options'                -- Load ./lua/options.lua
require 'keymaps'                -- Load ./lua/keymaps.lua
require 'autocmds'               -- Load ./lua/autocmds.lua
require 'highlighting'           -- Load ./lua/highlighting.lua

-- Add local dev directory `require` paths for testing from local development directories
-- Utils.add_to_path('/home/srackham/projects/markdown-blocks.nvim/lua')

-- Load auto spell correction abbreviations along with user abbreviations.
local abbreviations = require('abbreviations')
abbreviations.setup({
  -- Custom user abbreviations
  user_dict = {
    { "tsp",       "teaspoon" },
    { "tbsp",      "tablespoon" },
    { "tblsp",     "tablespoon" },
    { "btc",       "Bitcoin" },
    { "eth",       "Ethereum" },
    { "<expr> dd", "strftime('%d-%b-%Y')" },
    { "<expr> tt", "strftime('%H:%M')" },
    { "<expr> dt", "strftime('%d-%b-%Y %H:%M')" },
  }
})
-- abbreviations.typos_dict = {} -- Disable the builtin typos dictionary
abbreviations.load() -- Load abbreviations at startup
vim.keymap.set('n', '<Leader>al', function()
  abbreviations.load({ notify = true })
end, { noremap = true, silent = true, desc = "Load abbreviations" })
vim.keymap.set('n', '<Leader>at', abbreviations.toggle,
  { noremap = true, silent = true, desc = "Toggle abbreviations" })

-- Lastly load .nvimrc.lua file from root directory
local project_config_file = vim.fn.getcwd() .. '/.nvimrc.lua'
if vim.fn.filereadable(project_config_file) == 1 then
  vim.notify("Loading " .. project_config_file, vim.log.levels.INFO)
  local status_ok, err = pcall(dofile, project_config_file)
  if not status_ok then
    vim.notify("Error loading " .. project_config_file .. ": " .. err, vim.log.levels.ERROR)
  end
end
