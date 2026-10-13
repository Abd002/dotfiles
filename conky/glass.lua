-- Glass card system monitor, drawn with Cairo.
-- Reads sensors straight from /sys (by hwmon name, so it survives reboots that renumber them).
require 'cairo'

local W, H, R = 320, 482, 22 -- card size and corner radius
local FONT = 'Open Sans'
-- true: glass card behind everything. false: gauges and text float on the wallpaper,
-- with a soft shadow under them so they stay readable on light wallpapers too.
local CARD = false

-- Colours (r, g, b)
local TEXT = { 0.93, 0.95, 0.98 }
local MUTED = { 0.66, 0.71, 0.80 }
local ACCENT = { 0.53, 0.75, 0.82 } -- nord teal
local ACCENT2 = { 0.51, 0.63, 0.76 } -- nord blue
local WARN = { 0.92, 0.80, 0.55 }
local HOT = { 0.85, 0.42, 0.45 }

---------------------------------------------------------------- sensors

local function read(path)
  local f = io.open(path)
  if not f then return nil end
  local v = f:read '*l'
  f:close()
  return v
end

local hwmon_cache = {}
local function hwmon(name)
  if hwmon_cache[name] ~= nil then return hwmon_cache[name] or nil end
  for i = 0, 15 do
    local dir = '/sys/class/hwmon/hwmon' .. i
    if read(dir .. '/name') == name then
      hwmon_cache[name] = dir
      return dir
    end
  end
  hwmon_cache[name] = false
end

local function num(path, scale)
  local v = tonumber(read(path) or '')
  return v and v / (scale or 1) or nil
end

local function cpu_temp()
  local d = hwmon 'k10temp' or hwmon 'coretemp'
  return d and num(d .. '/temp1_input', 1000)
end

-- ASUS laptops: fan1 = CPU fan, fan2 = GPU fan
local function fan_rpm(n)
  local d = hwmon 'asus'
  return d and num(d .. '/fan' .. n .. '_input')
end

local function battery()
  local b = '/sys/class/power_supply/BAT0'
  local cap = num(b .. '/capacity')
  local full = num(b .. '/charge_full') or num(b .. '/energy_full')
  local design = num(b .. '/charge_full_design') or num(b .. '/energy_full_design')
  local health = (full and design and design > 0) and (full / design * 100) or nil
  return cap, health, read(b .. '/status')
end

-- nvidia-smi is a separate process, so only ask every 10 s (conky caches execi output)
local function gpu_temp()
  return tonumber(conky_parse '${execi 10 nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null}')
end

---------------------------------------------------------------- drawing helpers

local function rgba(cr, c, a) cairo_set_source_rgba(cr, c[1], c[2], c[3], a or 1) end

local function rounded(cr, x, y, w, h, r)
  cairo_new_sub_path(cr)
  cairo_arc(cr, x + w - r, y + r, r, -math.pi / 2, 0)
  cairo_arc(cr, x + w - r, y + h - r, r, 0, math.pi / 2)
  cairo_arc(cr, x + r, y + h - r, r, math.pi / 2, math.pi)
  cairo_arc(cr, x + r, y + r, r, math.pi, 3 * math.pi / 2)
  cairo_close_path(cr)
end

local function text(cr, s, x, y, size, color, alpha, weight, align)
  cairo_select_font_face(cr, FONT, CAIRO_FONT_SLANT_NORMAL, weight or CAIRO_FONT_WEIGHT_NORMAL)
  cairo_set_font_size(cr, size)
  local ext = cairo_text_extents_t:create()
  cairo_text_extents(cr, s, ext)
  if align == 'right' then
    x = x - ext.x_advance
  elseif align == 'center' then
    x = x - ext.x_advance / 2
  end
  if not CARD then -- soft shadow: a few offset passes in translucent black
    for _, o in ipairs { { 0, 1.5, 0.45 }, { 1, 1, 0.25 }, { -1, 1, 0.25 }, { 0, 0, 0.20 } } do
      cairo_set_source_rgba(cr, 0, 0, 0, o[3])
      cairo_move_to(cr, x + o[1], y + o[2])
      cairo_show_text(cr, s)
    end
  end
  rgba(cr, color, alpha)
  cairo_move_to(cr, x, y)
  cairo_show_text(cr, s)
  return ext.x_advance
end

local function divider(cr, x, y, w)
  rgba(cr, { 1, 1, 1 }, 0.10)
  cairo_rectangle(cr, x, y, w, 1)
  cairo_fill(cr)
end

local function trim(s) return (s or ''):match '^%s*(.-)%s*$' end

-- Shorten long process names ("WebKitWebProcess" -> "WebKitWebP…")
local function short(s, n)
  if #s <= n then return s end
  return s:sub(1, n) .. '…'
end

local function temp_color(t)
  if not t then return MUTED end
  if t >= 90 then return HOT end
  if t >= 75 then return WARN end
  return ACCENT
end

-- Half-ring gauge with the value in the middle
local function gauge(cr, cx, cy, r, value, max, color, label, unit)
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
  cairo_set_line_width(cr, 7)
  local a0, a1 = math.pi * 0.8, math.pi * 2.2
  rgba(cr, { 1, 1, 1 }, 0.10)
  cairo_new_path(cr) -- otherwise the arc is joined to the last text position by a stray line
  cairo_arc(cr, cx, cy, r, a0, a1)
  cairo_stroke(cr)
  if value then
    local frac = math.max(0, math.min(1, value / max))
    rgba(cr, color, 0.95)
    cairo_new_path(cr)
    cairo_arc(cr, cx, cy, r, a0, a0 + (a1 - a0) * frac)
    cairo_stroke(cr)
  end
  text(cr, value and string.format('%.0f', value) or '--', cx, cy + 9, 28, TEXT, 1, CAIRO_FONT_WEIGHT_NORMAL, 'center')
  text(cr, unit, cx + 18, cy - 8, 11, MUTED, 1, nil, 'left')
  text(cr, label, cx, cy + r + 8, 11, MUTED, 1, CAIRO_FONT_WEIGHT_BOLD, 'center')
end

-- Labelled progress bar
local function bar(cr, x, y, w, label, value_text, frac, color)
  text(cr, label, x, y, 12, MUTED, 1, CAIRO_FONT_WEIGHT_BOLD)
  text(cr, value_text, x + w, y, 12, TEXT, 1, nil, 'right')
  rounded(cr, x, y + 8, w, 6, 3)
  rgba(cr, { 1, 1, 1 }, 0.10)
  cairo_fill(cr)
  local fw = math.max(6, w * math.max(0, math.min(1, frac)))
  local g = cairo_pattern_create_linear(x, 0, x + fw, 0)
  cairo_pattern_add_color_stop_rgba(g, 0, ACCENT2[1], ACCENT2[2], ACCENT2[3], 0.9)
  cairo_pattern_add_color_stop_rgba(g, 1, color[1], color[2], color[3], 1)
  rounded(cr, x, y + 8, fw, 6, 3)
  cairo_set_source(cr, g)
  cairo_fill(cr)
  cairo_pattern_destroy(g)
end

---------------------------------------------------------------- main

function conky_glass()
  if conky_window == nil then return end
  local cs = conky_surface()
  if cs == nil then return end
  local cr = cairo_create(cs)

  -- Glass card: translucent tint, top sheen, hairline border
  if CARD then
    rounded(cr, 0.5, 0.5, W - 1, H - 1, R)
    rgba(cr, { 0.06, 0.08, 0.13 }, 0.46)
    cairo_fill_preserve(cr)
    local sheen = cairo_pattern_create_linear(0, 0, 0, H)
    cairo_pattern_add_color_stop_rgba(sheen, 0, 1, 1, 1, 0.12)
    cairo_pattern_add_color_stop_rgba(sheen, 0.35, 1, 1, 1, 0.03)
    cairo_pattern_add_color_stop_rgba(sheen, 1, 1, 1, 1, 0.0)
    cairo_set_source(cr, sheen)
    cairo_fill_preserve(cr)
    cairo_pattern_destroy(sheen)
    cairo_set_line_width(cr, 1)
    rgba(cr, { 1, 1, 1 }, 0.20)
    cairo_stroke(cr)
  end

  local pad = 24
  local inner = W - 2 * pad

  -- Temperatures, each with its own fan underneath
  local ct, gt = cpu_temp(), gpu_temp()
  local gx1, gx2, gy = pad + 58, W - pad - 58, 82
  gauge(cr, gx1, gy, 46, ct, 105, temp_color(ct), 'CPU', '°C')
  gauge(cr, gx2, gy, 46, gt, 100, temp_color(gt), 'GPU', '°C')
  for _, f in ipairs { { 1, gx1 }, { 2, gx2 } } do
    local rpm = fan_rpm(f[1])
    if rpm then
      text(cr, string.format('fan %.0f rpm', rpm), f[2], gy + 74, 12, rpm >= 5000 and WARN or MUTED, 1, nil, 'center')
    end
  end

  -- Usage bars
  local y = 186
  local cpu = tonumber(conky_parse '${cpu cpu0}') or 0
  bar(cr, pad, y, inner, 'CPU', string.format('%.0f%%  ·  %.1f GHz', cpu, (tonumber(conky_parse '${freq_g 1}') or 0)), cpu / 100, ACCENT)
  y = y + 40
  local mem = tonumber(conky_parse '${memperc}') or 0
  bar(cr, pad, y, inner, 'MEMORY', conky_parse '${mem} / ${memmax}', mem / 100, ACCENT)
  y = y + 40
  local disk = tonumber(conky_parse '${fs_used_perc /}') or 0
  bar(cr, pad, y, inner, 'DISK', conky_parse '${fs_used /} / ${fs_size /}', disk / 100, ACCENT)

  -- Top apps: biggest CPU users (left) and memory users (right)
  divider(cr, pad, y + 34, inner)
  y = y + 62
  local col2 = pad + inner / 2 + 8
  text(cr, 'TOP CPU', pad, y, 11, MUTED, 1, CAIRO_FONT_WEIGHT_BOLD)
  text(cr, 'TOP MEMORY', col2, y, 11, MUTED, 1, CAIRO_FONT_WEIGHT_BOLD)
  for i = 1, 3 do
    y = y + 20
    local cpu_name = trim(conky_parse('${top name ' .. i .. '}'))
    local cpu_pct = tonumber(conky_parse('${top cpu ' .. i .. '}')) or 0
    local mem_name = trim(conky_parse('${top_mem name ' .. i .. '}'))
    local mem_res = trim(conky_parse('${top_mem mem_res ' .. i .. '}'))
    text(cr, short(cpu_name, 10), pad, y, 12, TEXT)
    text(cr, string.format('%.0f%%', cpu_pct), pad + inner / 2 - 8, y, 12, cpu_pct >= 50 and WARN or MUTED, 1, nil, 'right')
    text(cr, short(mem_name, 10), col2, y, 12, TEXT)
    text(cr, mem_res, W - pad, y, 12, MUTED, 1, nil, 'right')
  end

  -- Footer: network, fan, battery
  divider(cr, pad, y + 16, inner)
  y = y + 42
  local iface = conky_parse '${gw_iface}'
  if iface == '' or iface == '(null)' then iface = 'lo' end
  local w = text(cr, 'download', pad, y, 11, MUTED, 1, CAIRO_FONT_WEIGHT_BOLD)
  text(cr, conky_parse('${downspeed ' .. iface .. '}'), pad + inner / 2 - 8, y, 13, TEXT, 1, nil, 'right')
  text(cr, 'upload', col2, y, 11, MUTED, 1, CAIRO_FONT_WEIGHT_BOLD)
  text(cr, conky_parse('${upspeed ' .. iface .. '}'), W - pad, y, 13, TEXT, 1, nil, 'right')

  y = y + 24
  local cap, health, status = battery()
  if cap then
    text(cr, 'battery', pad, y, 11, MUTED, 1, CAIRO_FONT_WEIGHT_BOLD)
    text(cr, string.format('%.0f%%%s', cap, status == 'Charging' and ' +' or ''), pad + inner / 2 - 8, y, 13, TEXT, 1, nil, 'right')
    if health then
      text(cr, 'health', col2, y, 11, MUTED, 1, CAIRO_FONT_WEIGHT_BOLD)
      text(cr, string.format('%d%%', math.floor(health + 0.5)), W - pad, y, 13, health < 40 and HOT or TEXT, 1, nil, 'right')
    end
  end

  cairo_destroy(cr) -- the surface belongs to conky, so only the context is freed
end
