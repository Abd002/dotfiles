-- Claude Code inside Neovim (same protocol as the VS Code extension).
-- Claude runs in a side panel, sees your current file and selection, and proposes edits as diffs:
-- accept with <leader>aa (or :w in the diff), reject with <leader>ad (or :q). You can edit the diff first.
return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  cmd = {
    'ClaudeCode',
    'ClaudeCodeFocus',
    'ClaudeCodeSelectModel',
    'ClaudeCodeAdd',
    'ClaudeCodeSend',
    'ClaudeCodeTreeAdd',
    'ClaudeCodeStatus',
    'ClaudeCodeStart',
    'ClaudeCodeStop',
    'ClaudeCodeOpen',
    'ClaudeCodeClose',
    'ClaudeCodeDiffAccept',
    'ClaudeCodeDiffDeny',
    'ClaudeCodeCloseAllDiffs',
  },
  opts = {
    terminal = {
      provider = 'snacks',
      split_side = 'right',
      split_width_percentage = 0.38,
    },
  },
  keys = {
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume a past conversation' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue last conversation' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select model' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current file to context' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send selection to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file under cursor',
      ft = { 'oil', 'snacks_picker_list', 'netrw' },
    },
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept Claude edit (diff)' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Reject Claude edit (diff)' },
    { '<leader>aD', '<cmd>ClaudeCodeCloseAllDiffs<cr>', desc = 'Close all pending diffs' },
    { '<leader>aS', '<cmd>ClaudeCodeStatus<cr>', desc = 'Connection status' },
  },
}
