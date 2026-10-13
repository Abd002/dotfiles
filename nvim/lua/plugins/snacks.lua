-- snacks.nvim: one plugin for the picker, file explorer, dashboard, indent guides, lazygit,
-- buffer delete, terminal (used by Claude Code), notifications and word highlighting.
-- Replaces telescope, neo-tree, alpha, indent-blankline, lazygit.nvim and vim-bbye.
return {
  'folke/snacks.nvim',
  version = '2.*',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true }, -- turn heavy features off in huge files
    quickfile = { enabled = true }, -- draw the file before plugins finish loading
    input = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    indent = { enabled = true, animate = { enabled = false } },
    scope = { enabled = true },
    words = { enabled = true }, -- highlight other uses of the word under the cursor; ]] / [[ jump
    explorer = { enabled = true, replace_netrw = false }, -- oil handles directories
    picker = {
      enabled = true,
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        explorer = { hidden = true },
      },
      win = {
        input = {
          keys = { -- keep the <C-j>/<C-k> you used in telescope
            ['<C-j>'] = { 'list_down', mode = { 'i', 'n' } },
            ['<C-k>'] = { 'list_up', mode = { 'i', 'n' } },
          },
        },
      },
    },
    lazygit = { enabled = true },
    terminal = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        keys = {
          { icon = ' ', key = 'f', desc = 'Find file', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = ' ', key = 'g', desc = 'Grep text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = ' ', key = 'r', desc = 'Recent files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = ' ', key = 's', desc = 'Restore session', section = 'session' },
          { icon = '󰊢 ', key = 'G', desc = 'Lazygit', action = ':lua Snacks.lazygit()' },
          { icon = '󰚩 ', key = 'a', desc = 'Claude Code', action = ':ClaudeCode' },
          { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = '󰒲 ', key = 'L', desc = 'Lazy (plugins)', action = ':Lazy' },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },
  },
  -- stylua: ignore
  keys = {
    -- Top level: the three things you do most
    { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Find files (smart)' },
    { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep project' },
    { '<leader>e', function() Snacks.explorer() end, desc = 'File explorer' },

    -- f: find
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Files' },
    { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Git files' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent files' },
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Neovim config files' },
    { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },
    { '<leader>fe', function() Snacks.explorer() end, desc = 'File explorer' },

    -- s: search
    { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep project' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Word under cursor / selection', mode = { 'n', 'x' } },
    { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Lines in buffer' },
    { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep open buffers' },
    { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help pages' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
    { '<leader>sc', function() Snacks.picker.commands() end, desc = 'Commands' },
    { '<leader>s:', function() Snacks.picker.command_history() end, desc = 'Command history' },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics (project)' },
    { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Diagnostics (buffer)' },
    { '<leader>ss', function() Snacks.picker.lsp_symbols() end, desc = 'Symbols (buffer)' },
    { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'Symbols (project)' },
    { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },
    { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jump list' },
    { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix list' },
    { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Resume last search' },
    { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo history' },
    { '<leader>sn', function() Snacks.notifier.show_history() end, desc = 'Notification history' },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers' },

    -- g: git
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
    { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Log (project)' },
    { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Log (current file)' },
    { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Log (current line)' },
    { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Status' },
    { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Branches' },
    { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Stash' },
    { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Diff (changed hunks)' },
    { '<leader>go', function() Snacks.gitbrowse() end, desc = 'Open in browser (GitHub)', mode = { 'n', 'v' } },

    -- b: buffers
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete buffer' },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete other buffers' },
    { '<leader>bs', function() Snacks.scratch() end, desc = 'Scratch buffer' },

    -- t: terminal (u: toggles are set up in init below)
    { '<leader>tt', function() Snacks.terminal() end, desc = 'Toggle terminal' },
    { '<leader>uz', function() Snacks.zen() end, desc = 'Zen mode' },
    { '<leader>uZ', function() Snacks.zen.zoom() end, desc = 'Zoom window' },

    -- Jump between highlighted uses of the word under the cursor
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next reference', mode = { 'n', 't' } },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Previous reference', mode = { 'n', 't' } },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- u: toggles. Each shows its state in the which-key menu.
        Snacks.toggle.option('wrap', { name = 'Line wrap' }):map '<leader>uw'
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('relativenumber', { name = 'Relative numbers' }):map '<leader>ul'
        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle.inlay_hints():map '<leader>uh'
        Snacks.toggle.treesitter():map '<leader>uT'
        Snacks.toggle.indent():map '<leader>ug'
        Snacks.toggle.dim():map '<leader>uD'
      end,
    })
  end,
}
