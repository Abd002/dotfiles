-- Key cheat sheet inside Neovim.
--   <leader>K   open CHEATSHEET.md in a floating window (search with /, n / N, close with q)
--   <leader>sK  fuzzy-search the cheat sheet lines; Enter opens the sheet at that line
-- CHEATSHEET.md is generated from CHEATSHEET.html by cheatsheet-gen.js, so both list the same keys.
local M = {}

local function path()
  return vim.fn.stdpath 'config' .. '/CHEATSHEET.md'
end

function M.open(line)
  local file = path()
  if vim.fn.filereadable(file) == 0 then
    vim.notify('Cheat sheet not found: ' .. file, vim.log.levels.ERROR)
    return
  end
  local win = Snacks.win {
    file = file,
    width = 0.8,
    height = 0.85,
    border = 'rounded',
    title = ' Neovim keys  ·  / search  ·  n N next/prev  ·  q close ',
    title_pos = 'center',
    bo = { modifiable = false, readonly = true },
    wo = { wrap = false, conceallevel = 0, cursorline = true, number = false, relativenumber = false, spell = false },
    keys = { q = 'close', ['<Esc>'] = 'close' },
  }
  if line and win.win and vim.api.nvim_win_is_valid(win.win) then
    vim.api.nvim_win_set_cursor(win.win, { line, 0 })
    vim.cmd 'normal! zz'
  end
  return win
end

function M.search()
  local items = {}
  local section = ''
  for i, text in ipairs(vim.fn.readfile(path())) do
    if text:match '^#' then
      section = text:gsub('^#+%s*', '')
    elseif text:match '%S' then
      -- the section name is searchable too ("rust test", "git blame")
      items[#items + 1] = { text = text .. '  ' .. section, line = i, display = vim.trim(text), section = section }
    end
  end
  return Snacks.picker {
    title = 'Cheat sheet',
    items = items,
    layout = { preset = 'select' },
    format = function(item)
      return { { item.display }, { '   ' .. item.section, 'Comment' } }
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.schedule(function() M.open(item.line) end)
      end
    end,
  }
end

return M
