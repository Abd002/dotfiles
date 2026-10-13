return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    signs_staged = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },

    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Jump between changed blocks ("hunks"); in diff mode ]h / [h jump between diff changes ([c / ]c is classes)
      local function nav(dir, vim_key)
        return function()
          if vim.wo.diff then
            vim.cmd.normal { vim_key, bang = true }
          else
            gitsigns.nav_hunk(dir)
          end
        end
      end
      map('n', ']h', nav('next', ']c'), { desc = 'Next git hunk' })
      map('n', '[h', nav('prev', '[c'), { desc = 'Previous git hunk' })

      -- gh: hunks
      map({ 'n', 'x' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage hunk (or selection)' })
      map({ 'n', 'x' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset hunk (or selection)' })
      map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'Stage whole file' })
      map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'Reset whole file' })
      map('n', '<leader>ghp', gitsigns.preview_hunk_inline, { desc = 'Preview hunk' })
      map('n', '<leader>ghb', function() gitsigns.blame_line { full = true } end, { desc = 'Blame line' })
      map('n', '<leader>ghB', gitsigns.blame, { desc = 'Blame file' })
      map('n', '<leader>ghd', gitsigns.diffthis, { desc = 'Diff against index' })
      map('n', '<leader>ghD', function() gitsigns.diffthis '~' end, { desc = 'Diff against last commit' })
      map('n', '<leader>ub', gitsigns.toggle_current_line_blame, { desc = 'Toggle inline blame' })
      -- "ih" text object: dih deletes a hunk, vih selects it
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Git hunk' })
    end,
  },
}
