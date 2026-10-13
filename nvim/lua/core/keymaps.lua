-- General keymaps. Plugin keymaps live in each plugin file; the which-key group names are in
-- plugins/editor.lua. Press <leader> (Space) and wait to see every group, or <leader>sk to search keys.
--
-- Leader groups:  a AI   b buffers   c code   d debug   D database   f find   g git   h harpoon
--                 q session   r rust   s search   t terminal/tabs   u toggles   w windows   x problems

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = function(mode, lhs, rhs, desc, extra)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', { silent = true, desc = desc }, extra or {}))
end

-- Space does nothing on its own (it is the leader key)
map({ 'n', 'v' }, '<Space>', '<Nop>')

-- Move through wrapped lines with j / k (counts like 5j still jump real lines)
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", 'Up', { expr = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", 'Down', { expr = true })

-- Leave insert mode with jk / kj
map('i', 'jk', '<Esc>', 'Exit insert mode')
map('i', 'kj', '<Esc>', 'Exit insert mode')

-- Clear search highlight
map('n', '<Esc>', '<cmd>noh<CR><Esc>', 'Clear highlight')

-- Save / quit
map('n', '<C-s>', '<cmd>w<CR>', 'Save (and format)')
map('n', '<leader>bw', '<cmd>noautocmd w<CR>', 'Save without formatting')
map('n', '<C-q>', '<cmd>q<CR>', 'Quit window')
map('n', '<leader>qq', '<cmd>qa<CR>', 'Quit Neovim')

-- Delete a character without overwriting the clipboard
map('n', 'x', '"_x', 'Delete char (keep clipboard)')
-- Paste over a selection without losing what you copied
map('v', 'p', '"_dP', 'Paste (keep clipboard)')
-- Copy to the system clipboard explicitly
map({ 'n', 'v' }, '<leader>y', [["+y]], 'Copy to system clipboard')
map('n', '<leader>Y', [["+Y]], 'Copy line to system clipboard')

-- Keep the cursor centred when scrolling and searching
map('n', '<C-d>', '<C-d>zz', 'Half page down')
map('n', '<C-u>', '<C-u>zz', 'Half page up')
map('n', 'n', 'nzzzv', 'Next match')
map('n', 'N', 'Nzzzv', 'Previous match')

-- Change the word under the cursor, then press . to change the next match
map('n', '<leader>cw', '*``cgn', 'Change word (repeat with .)')

-- Numbers
map('n', '<leader>+', '<C-a>', 'Increment number')
map('n', '<leader>-', '<C-x>', 'Decrement number')

-- Comments (Neovim's built-in gc): Ctrl+/ like in other editors. Terminals send Ctrl+/ as Ctrl+_
map('n', '<C-/>', 'gcc', 'Toggle comment', { remap = true })
map('n', '<C-_>', 'gcc', 'Toggle comment', { remap = true })
map('n', '<C-c>', 'gcc', 'Toggle comment', { remap = true })
map('x', '<C-/>', 'gc', 'Toggle comment', { remap = true })
map('x', '<C-_>', 'gc', 'Toggle comment', { remap = true })
map('x', '<C-c>', 'gc', 'Toggle comment', { remap = true })

-- Indent and keep the selection
map('v', '<', '<gv', 'Indent left')
map('v', '>', '>gv', 'Indent right')

-- Move lines up / down
map('n', '<A-j>', '<cmd>m .+1<CR>==', 'Move line down')
map('n', '<A-k>', '<cmd>m .-2<CR>==', 'Move line up')
map('v', '<A-j>', ":m '>+1<CR>gv=gv", 'Move selection down')
map('v', '<A-k>', ":m '<-2<CR>gv=gv", 'Move selection up')

-- Buffers. (<Tab> is left alone: terminals send <Tab> and <C-i> as the same key,
-- so mapping it breaks "jump forward" <C-i>. Use Shift+h / Shift+l instead.)
map('n', '<S-h>', '<cmd>bprevious<CR>', 'Previous buffer')
map('n', '<S-l>', '<cmd>bnext<CR>', 'Next buffer')
map('n', '[b', '<cmd>bprevious<CR>', 'Previous buffer')
map('n', ']b', '<cmd>bnext<CR>', 'Next buffer')
map('n', '<leader>bn', '<cmd>enew<CR>', 'New empty buffer')
map('n', '<leader>bb', '<cmd>e #<CR>', 'Switch to last buffer')

-- Windows: <leader>w is the same as Ctrl+w (wv split right, ws split below, wq close, w= equal)
map('n', '<leader>|', '<C-w>v', 'Split right')
map('n', '<leader>_', '<C-w>s', 'Split below')
map('n', '<Up>', '<cmd>resize -2<CR>', 'Shrink window height')
map('n', '<Down>', '<cmd>resize +2<CR>', 'Grow window height')
map('n', '<Left>', '<cmd>vertical resize -2<CR>', 'Shrink window width')
map('n', '<Right>', '<cmd>vertical resize +2<CR>', 'Grow window width')
-- Ctrl+h/j/k/l move between windows and tmux panes (plugins/vim-tmux-navigator.lua)

-- Tabs
map('n', '<leader>to', '<cmd>tabnew<CR>', 'New tab')
map('n', '<leader>tx', '<cmd>tabclose<CR>', 'Close tab')
map('n', '<leader>tn', '<cmd>tabnext<CR>', 'Next tab')
map('n', '<leader>tp', '<cmd>tabprevious<CR>', 'Previous tab')

-- Diagnostics (problems)
map('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end, 'Previous diagnostic')
map('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end, 'Next diagnostic')
map('n', '[e', function() vim.diagnostic.jump { count = -1, float = true, severity = vim.diagnostic.severity.ERROR } end, 'Previous error')
map('n', ']e', function() vim.diagnostic.jump { count = 1, float = true, severity = vim.diagnostic.severity.ERROR } end, 'Next error')
map('n', '[q', '<cmd>cprevious<CR>', 'Previous quickfix item')
map('n', ']q', '<cmd>cnext<CR>', 'Next quickfix item')

-- Cheat sheet (lua/core/cheatsheet.lua)
map('n', '<leader>K', function() require('core.cheatsheet').open() end, 'Cheat sheet (all keys)')
map('n', '<leader>sK', function() require('core.cheatsheet').search() end, 'Search the cheat sheet')

-- Glass / solid background (lua/core/transparency.lua)
map('n', '<leader>ut', function() require('core.transparency').toggle() end, 'Transparent background')

-- Tools
map('n', '<leader>l', '<cmd>Lazy<CR>', 'Lazy (plugin manager)')
map('n', '<leader>cM', '<cmd>Mason<CR>', 'Mason (install language tools)')
