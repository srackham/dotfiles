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

-- Set the following options before LazyVim setup is executed.
vim.g.mapleader = ','
vim.g.maplocalleader = '\\'
vim.g.editorconfig = false -- Disable .editorconfig files globally
vim.g.vim_init_file = vim.fn.stdpath('config') .. '/vim/init.vim'

vim.o.winborder = 'single'

-- Load abbreviations et al
vim.cmd('source ' .. vim.g.vim_init_file)

require('lazy').setup('plugins') -- Load ./lua/plugins/*.lua
require 'options'                -- Load ./lua/options.lua
require 'keymaps'                -- Load ./lua/keymaps.lua
require 'autocmds'               -- Load ./lua/autocmds.lua
require 'highlighting'           -- Load ./lua/highlighting.lua

-- Lastly load .nvimrc.lua file from root directory
local project_config_file = vim.fn.getcwd() .. '/.nvimrc.lua'
if vim.fn.filereadable(project_config_file) == 1 then
  vim.notify("Loading " .. project_config_file, vim.log.levels.INFO)
  local status_ok, err = pcall(dofile, project_config_file)
  if not status_ok then
    vim.notify("Error loading " .. project_config_file .. ": " .. err, vim.log.levels.ERROR)
  end
end
