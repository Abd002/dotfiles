-- Formatting (conform.nvim) and linting (nvim-lint). Replaces none-ls + mason-null-ls.
-- Tools are installed by mason-tool-installer (see lsp.lua).
return {
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    keys = {
      { '<leader>cf', function() require('conform').format { async = true } end, mode = { 'n', 'x' }, desc = 'Format buffer / selection' },
      { '<leader>cF', '<cmd>ConformInfo<cr>', desc = 'Formatter info' },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_organize_imports', 'ruff_format' },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        terraform = { 'terraform_fmt' },
        -- rust: rust-analyzer formats with rustfmt (lsp fallback below)
      },
      formatters = {
        shfmt = { prepend_args = { '-i', '4' } },
        -- clang-format uses the project's .clang-format, else ~/.clang-format from these dotfiles
        -- (LLVM, 4 spaces). It only accepts a style name for --fallback-style, so none is set here.
      },
      default_format_opts = { lsp_format = 'fallback' },
      -- Format when you save yourself, but not on the background auto-save (core/options.lua),
      -- so code is not rewritten while you are still typing. <leader>uf turns it off.
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat or vim.b[bufnr].autosaving then
          return
        end
        return { timeout_ms = 3000, lsp_format = 'fallback' }
      end,
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          Snacks.toggle({
            name = 'Format on save',
            get = function() return not vim.g.disable_autoformat end,
            set = function(state) vim.g.disable_autoformat = not state end,
          }):map '<leader>uf'
        end,
      })
    end,
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufWritePost', 'InsertLeave' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        make = { 'checkmake' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
      }
      vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
        callback = function()
          lint.try_lint(nil, { ignore_errors = true }) -- skips linters that are not installed
        end,
      })
    end,
  },
}
