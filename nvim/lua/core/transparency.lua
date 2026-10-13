-- Transparent Neovim, so the terminal's glass (COSMIC Terminal opacity / blur) shows through.
-- The colorscheme already leaves the main editor background empty; this also clears the panels,
-- popups, gutter, tabline and status line that plugins paint with solid colours.
-- <leader>ut switches between glass and solid. Works with any colorscheme.
local M = {}

M.enabled = true

-- Highlight groups (exact names) whose background is removed
local groups = {
  'Normal', 'NormalNC', 'NormalFloat', 'FloatBorder', 'FloatTitle', 'FloatFooter',
  'SignColumn', 'LineNr', 'LineNrAbove', 'LineNrBelow', 'CursorLineNr', 'CursorLineSign', 'CursorLineFold',
  'FoldColumn', 'Folded', 'EndOfBuffer', 'WinSeparator', 'VertSplit',
  'StatusLine', 'StatusLineNC', 'TabLine', 'TabLineFill', 'WinBar', 'WinBarNC',
  'Pmenu', 'PmenuSbar', 'MsgArea', 'MsgSeparator',
  'DiagnosticVirtualTextError', 'DiagnosticVirtualTextWarn', 'DiagnosticVirtualTextInfo', 'DiagnosticVirtualTextHint',
  'GitSignsAdd', 'GitSignsChange', 'GitSignsDelete',
}

-- Every group starting with one of these prefixes (plugin panels and popups)
local prefixes = {
  'Snacks', 'WhichKey', 'Trouble', 'BlinkCmp', 'Lazy', 'Mason', 'Aerial', 'Oil', 'GrugFar',
  'BufferLine', 'lualine_c', 'lualine_x', 'NeoTree', 'Telescope', 'Noice', 'Notify', 'Dap',
}

-- Selected / highlighted things keep their background so you can still see what is selected
local keep = { Sel = true, Visual = true, Selected = true, Match = true, Cursor = true, Search = true }

local function keeps_bg(name)
  for word in pairs(keep) do
    if name:find(word) then return true end
  end
  return false
end

local function clear(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok or not hl or vim.tbl_isempty(hl) then return end
  hl.bg = nil
  hl.ctermbg = nil
  vim.api.nvim_set_hl(0, name, hl)
end

function M.apply()
  if not M.enabled then return end
  for _, name in ipairs(groups) do clear(name) end
  for name in pairs(vim.api.nvim_get_hl(0, {})) do
    for _, prefix in ipairs(prefixes) do
      if name:sub(1, #prefix) == prefix and not keeps_bg(name) then
        clear(name)
        break
      end
    end
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup('transparency', { clear = true })
  -- after every colorscheme load, and once the UI plugins (lualine, bufferline) have made their groups
  vim.api.nvim_create_autocmd('ColorScheme', { group = group, callback = function() vim.schedule(M.apply) end })
  vim.api.nvim_create_autocmd({ 'VimEnter', 'User' }, {
    group = group,
    pattern = { '*', 'VeryLazy', 'LazyLoad' },
    callback = function() vim.schedule(M.apply) end,
  })
  vim.schedule(M.apply)
end

function M.toggle()
  M.enabled = not M.enabled
  -- both themes have their own "no background" switch for the main editor area
  vim.g.nord_disable_background = M.enabled
  local ok, onedark = pcall(require, 'onedark')
  if ok and vim.g.colors_name == 'onedark' then
    onedark.setup { transparent = M.enabled }
  end
  -- reload the colorscheme to get the solid colours back, or clear them again
  vim.cmd.colorscheme(vim.g.colors_name)
  vim.notify(M.enabled and 'Glass background' or 'Solid background', vim.log.levels.INFO)
end

return M
