-- C / C++: clangd extras on top of the clangd server set up in lsp.lua.
return {
  'p00f/clangd_extensions.nvim',
  ft = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  opts = {
    inlay_hints = { inline = true },
    ast = {
      role_icons = { type = '', declaration = '', expression = '', specifier = '', statement = '', ['template argument'] = '' },
    },
  },
  config = function(_, opts)
    require('clangd_extensions').setup(opts)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('cpp-keys', { clear = true }),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client or client.name ~= 'clangd' then return end
        local map = function(lhs, rhs, desc)
          vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = 'C/C++: ' .. desc })
        end
        -- C/C++ keys live in the "code" group
        map('<leader>ch', '<cmd>LspClangdSwitchSourceHeader<cr>', 'Switch header / source')
        map('<leader>cA', '<cmd>ClangdAST<cr>', 'Show AST of node')
        map('<leader>ct', '<cmd>ClangdTypeHierarchy<cr>', 'Type hierarchy')
        map('<leader>cm', '<cmd>ClangdMemoryUsage<cr>', 'clangd memory usage')
        map('<leader>ci', '<cmd>ClangdSymbolInfo<cr>', 'Symbol info')
      end,
    })
  end,
}
