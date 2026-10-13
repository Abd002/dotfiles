-- Completion: blink.cmp (fast, built-in fuzzy matching, signature help) with LuaSnip snippets.
-- Replaces nvim-cmp and its source plugins. Keys match what you used with nvim-cmp.
return {
  'saghen/blink.cmp',
  version = '1.*', -- release tags ship a prebuilt fuzzy matcher
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
      dependencies = { 'rafamadriz/friendly-snippets' },
      config = function()
        local luasnip = require 'luasnip'
        require('luasnip.loaders.from_vscode').lazy_load()

        -- "template" snippet in C++ files: your competitive-programming template
        local template_path = vim.fn.stdpath 'config' .. '/templates/cpp.template'
        local lines = {}
        local file = io.open(template_path, 'r')
        if file then
          for line in file:lines() do
            table.insert(lines, (line:gsub('\r', '')))
          end
          file:close()
          luasnip.add_snippets('cpp', { luasnip.snippet('template', { luasnip.text_node(lines) }) })
        end
      end,
    },
  },
  opts = {
    snippets = { preset = 'luasnip' },
    keymap = {
      preset = 'none',
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      ['<C-l>'] = { 'snippet_forward', 'fallback' },
      ['<C-h>'] = { 'snippet_backward', 'fallback' },
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      list = { selection = { preselect = true, auto_insert = false } },
      documentation = { auto_show = true, auto_show_delay_ms = 250 },
      menu = {
        draw = { columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } } },
      },
    },
    signature = { enabled = true },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    cmdline = { enabled = true },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
