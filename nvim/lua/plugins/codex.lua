return {
  'pittcat/codex.nvim',
  cmd = { 'Codex', 'CodexToggle', 'CodexSendPath', 'CodexSendSelection', 'CodexSendReference' },
  keys = {
    { '<leader>co', function() require('codex').open() end, desc = 'Codex: Open TUI' },
    { '<leader>ct', function() require('codex').toggle() end, desc = 'Codex: Toggle terminal' },
    { '<leader>cp', ':CodexSendPath<CR>', desc = 'Codex: Send file path' },
    { '<leader>cs', ":'<,'>CodexSendSelection<CR>", mode = 'v', desc = 'Codex: Send visual selection' },
    { '<leader>cr', ":'<,'>CodexSendReference<CR>", mode = 'v', desc = 'Codex: Send selection as reference' },
  },
  config = function()
    require('codex').setup({
      terminal = {
        direction = 'vertical',    -- left/right split
        size = 0.35,               -- 35% of the current window width
        position = 'right',        -- opens to the right
      },
    })
  end,
}
