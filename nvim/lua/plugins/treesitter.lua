-- Highlight, edit, and navigate code
-- Uses the nvim-treesitter `main` branch (required for Neovim 0.12+). It has no `configs.setup`
-- module: parsers are installed with `install()`, and highlighting/indent are turned on per buffer.
local parsers = {
  'lua',
  'python',
  'javascript',
  'typescript',
  'vimdoc',
  'vim',
  'regex',
  'terraform',
  'sql',
  'dockerfile',
  'toml',
  'json',
  'java',
  'groovy',
  'go',
  'gitignore',
  'graphql',
  'yaml',
  'make',
  'cmake',
  'markdown',
  'markdown_inline',
  'bash',
  'tsx',
  'css',
  'html',
  'c',
  'cpp',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- the main branch does not support lazy-loading
  build = ':TSUpdate',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
  },
  config = function()
    local ts = require 'nvim-treesitter'
    ts.install(parsers)

    -- Start highlighting + indentation for every buffer that has a parser.
    -- Parsers that are not installed yet are installed on first use (old `auto_install = true`).
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end
        local function start()
          if pcall(vim.treesitter.start, args.buf, lang) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end
        if vim.list_contains(ts.get_installed(), lang) then
          start()
        elseif vim.list_contains(ts.get_available(), lang) then
          ts.install(lang):await(function()
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(args.buf) then
                start()
              end
            end)
          end)
        end
      end,
    })

    -- Textobjects
    require('nvim-treesitter-textobjects').setup {
      select = { lookahead = true }, -- Automatically jump forward to textobj, similar to targets.vim
      move = { set_jumps = true }, -- whether to set jumps in the jumplist
    }

    local select = require 'nvim-treesitter-textobjects.select'
    for keys, query in pairs {
      ['aa'] = '@parameter.outer',
      ['ia'] = '@parameter.inner',
      ['af'] = '@function.outer',
      ['if'] = '@function.inner',
      ['ac'] = '@class.outer',
      ['ic'] = '@class.inner',
    } do
      vim.keymap.set({ 'x', 'o' }, keys, function()
        select.select_textobject(query, 'textobjects')
      end, { desc = 'Select ' .. query })
    end

    local move = require 'nvim-treesitter-textobjects.move'
    for fn, maps in pairs {
      goto_next_start = { [']m'] = '@function.outer', [']c'] = '@class.outer' },
      goto_next_end = { [']M'] = '@function.outer', [']C'] = '@class.outer' },
      goto_previous_start = { ['[m'] = '@function.outer', ['[c'] = '@class.outer' },
      goto_previous_end = { ['[M'] = '@function.outer', ['[C'] = '@class.outer' },
      -- ]] / [[ jump between uses of the word under the cursor (snacks.lua)
    } do
      for keys, query in pairs(maps) do
        vim.keymap.set({ 'n', 'x', 'o' }, keys, function()
          move[fn](query, 'textobjects')
        end, { desc = fn .. ' ' .. query })
      end
    end

    local swap = require 'nvim-treesitter-textobjects.swap'
    vim.keymap.set('n', '<leader>cs', function()
      swap.swap_next '@parameter.inner'
    end, { desc = 'Swap with next parameter' })
    vim.keymap.set('n', '<leader>cS', function()
      swap.swap_previous '@parameter.inner'
    end, { desc = 'Swap with previous parameter' })

    -- Register additional file extensions
    vim.filetype.add { extension = { tf = 'terraform' } }
    vim.filetype.add { extension = { tfvars = 'terraform' } }
    vim.filetype.add { extension = { pipeline = 'groovy' } }
    vim.filetype.add { extension = { multibranch = 'groovy' } }
  end,
}
