return {
  'stevearc/aerial.nvim',
  lazy_load = true,
  opts = {},
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('aerial').setup {
      -- optionally use on_attach to set keymaps when aerial has attached to a buffer
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = 'Previous symbol' })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = 'Next symbol' })
      end,
      layout = {
        min_width = 30,
      },
    }
    -- You probably also want to set a keymap to toggle aerial
    vim.keymap.set('n', '<leader>co', '<cmd>AerialToggle!<CR>', { desc = 'Outline (symbols sidebar)' })
    vim.keymap.set('n', '<leader>cO', '<cmd>AerialNavToggle<CR>', { desc = 'Outline navigator' })
  end,
}
