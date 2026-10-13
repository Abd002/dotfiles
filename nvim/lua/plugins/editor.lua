-- Editing and navigation helpers, and the which-key menu that names every key group.
return {
  {
    -- Press <leader> and wait: a menu shows every group and key. Press <leader>? for buffer keys.
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'helix',
      delay = 400,
      spec = {
        { '<leader>a', group = 'AI (Claude)', icon = '󰚩 ' },
        { '<leader>b', group = 'buffers' },
        { '<leader>c', group = 'code' },
        { '<leader>d', group = 'debug' },
        { '<leader>D', group = 'database / SQL' },
        { '<leader>f', group = 'find' },
        { '<leader>g', group = 'git' },
        { '<leader>gh', group = 'hunks' },
        { '<leader>h', group = 'harpoon' },
        { '<leader>q', group = 'session / quit' },
        { '<leader>r', group = 'rust' },
        { '<leader>s', group = 'search' },
        { '<leader>t', group = 'terminal / tabs' },
        { '<leader>u', group = 'toggles' },
        { '<leader>w', group = 'windows', proxy = '<c-w>' },
        { '<leader>x', group = 'problems (diagnostics / quickfix)' },
        { '[', group = 'previous' },
        { ']', group = 'next' },
        { 'g', group = 'go to' },
        { 'gs', group = 'surround' },
        { 'z', group = 'fold' },
      },
    },
    keys = {
      { '<leader>?', function() require('which-key').show { global = false } end, desc = 'Keys for this buffer' },
    },
  },
  {
    -- Jump anywhere on screen: press s, type 2 letters, press the label
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = { modes = { search = { enabled = false } } },
    -- stylua: ignore
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash jump' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash select (treesitter)' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote flash' },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter search' },
    },
  },
  {
    -- A proper problems panel: diagnostics, quickfix, references, todos
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = { modes = { lsp = { win = { position = 'right' } } } },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (project)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Diagnostics (buffer)' },
      { '<leader>xs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols' },
      { '<leader>xr', '<cmd>Trouble lsp toggle<cr>', desc = 'LSP references / definitions' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix list' },
      { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Location list' },
      { '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'TODOs' },
      { '<leader>cd', vim.diagnostic.open_float, desc = 'Line diagnostics' },
    },
  },
  {
    -- Highlight TODO / FIXME / HACK / NOTE in comments
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    opts = { signs = false },
    -- stylua: ignore
    keys = {
      { ']t', function() require('todo-comments').jump_next() end, desc = 'Next TODO' },
      { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous TODO' },
      { '<leader>st', function() Snacks.picker.todo_comments() end, desc = 'TODOs' },
    },
  },
  {
    -- Search and replace across the whole project, with a live preview
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        '<leader>sr',
        function()
          local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
          require('grug-far').open { transient = true, prefills = { filesFilter = ext and ext ~= '' and '*.' .. ext or nil } }
        end,
        mode = { 'n', 'x' },
        desc = 'Search & replace (project)',
      },
    },
  },
  {
    -- Add / delete / replace surroundings: gsa iw" , gsd" , gsr"'
    'echasnovski/mini.surround',
    version = '*',
    keys = { { 'gs', '', desc = '+surround', mode = { 'n', 'x' } } },
    opts = {
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsr',
        update_n_lines = 'gsn',
      },
    },
  },
  {
    -- Sessions per project folder (replaces the old .session.vim files)
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
    -- stylua: ignore
    keys = {
      { '<leader>qs', function() require('persistence').load() end, desc = 'Restore session (this folder)' },
      { '<leader>qS', function() require('persistence').select() end, desc = 'Pick a session' },
      { '<leader>ql', function() require('persistence').load { last = true } end, desc = 'Restore last session' },
      { '<leader>qd', function() require('persistence').stop() end, desc = "Don't save this session" },
    },
  },
}
