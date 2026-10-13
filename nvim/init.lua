require 'core.options' -- Load general options
require 'core.keymaps' -- Load general keymaps
require 'core.snippets' -- Custom code snippets
require 'core.templates' -- Custom file templates
require 'tools.sql-runner'

-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Import color theme based on environment variable NVIM_THEME
local default_color_scheme = 'nord'
local env_var_nvim_theme = os.getenv 'NVIM_THEME' or default_color_scheme

-- Define a table of theme modules
local themes = {
  nord = 'plugins.themes.nord',
  onedark = 'plugins.themes.onedark',
}

-- Setup plugins
require('lazy').setup({
  require(themes[env_var_nvim_theme]),
  require 'plugins.snacks', -- picker, explorer, dashboard, terminal, lazygit, notifications
  require 'plugins.editor', -- which-key menu, flash, trouble, todo, search & replace, surround, sessions
  require 'plugins.treesitter',
  require 'plugins.lsp',
  require 'plugins.completion', -- blink.cmp + LuaSnip
  require 'plugins.formatting', -- conform + nvim-lint
  require 'plugins.rust', -- rustaceanvim + crates.nvim
  require 'plugins.cpp', -- clangd extras
  require 'plugins.lualine',
  require 'plugins.bufferline',
  require 'plugins.oil',
  require 'plugins.debug',
  require 'plugins.gitsigns',
  require 'plugins.database',
  require 'plugins.misc',
  require 'plugins.harpoon',
  -- require 'plugins.avante',
  require 'plugins.aerial',
  require 'plugins.vim-tmux-navigator',
  require 'plugins.ai-complation', -- Codeium
  require 'plugins.claude', -- Claude Code
  require 'plugins.codex',
}, {
  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Glass background: let the terminal's transparency show through (toggle with <leader>ut)
require('core.transparency').setup()

-- Sessions: persistence.nvim saves one per folder; restore with <leader>qs or from the dashboard.

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = '#10b981', bg = 'NONE' })
