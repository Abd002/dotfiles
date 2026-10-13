-- OpenAI Codex (kept next to Claude in the AI group: <leader>ao / at / ap / ax / aX)
return {
  'pittcat/codex.nvim',
  cmd = { 'Codex', 'CodexToggle', 'CodexSendPath', 'CodexSendSelection', 'CodexSendReference' },
  keys = {
    { '<leader>ao', function() require('codex').open() end, desc = 'Codex: Open TUI' },
    { '<leader>at', function() require('codex').toggle() end, desc = 'Codex: Toggle terminal' },
    { '<leader>ap', ':CodexSendPath<CR>', desc = 'Codex: Send file path' },
    { '<leader>ax', ":'<,'>CodexSendSelection<CR>", mode = 'v', desc = 'Codex: Send visual selection' },
    { '<leader>aX', ":'<,'>CodexSendReference<CR>", mode = 'v', desc = 'Codex: Send selection as reference' },
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
