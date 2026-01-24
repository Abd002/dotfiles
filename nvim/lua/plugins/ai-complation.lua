return {
  -- Official Codeium plugin for Vim/Neovim
  'Exafunction/codeium.vim',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = 'Codeium', -- so :Codeium Auth works even before InsertEnter

  -- If <Tab> conflicts with your cmp/snippets, disable Codeium defaults
  init = function()
    vim.g.codeium_disable_bindings = 1
  end,

  config = function()
    -- Accept suggestion
    vim.keymap.set('i', '<C-g>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true, silent = true, desc = 'Codeium accept' })

    -- Clear suggestion
    vim.keymap.set('i', '<C-x>', function()
      return vim.fn['codeium#Clear']()
    end, { expr = true, silent = true, desc = 'Codeium clear' })

    -- Next suggestion
    vim.keymap.set('i', '<M-]>', function()
      return vim.fn
    end, { expr = true, silent = true, desc = 'Codeium next' })

    -- Previous suggestion
    vim.keymap.set('i', '<M-[>', function()
      return vim.fn['codeium#CycleCompletions'](-1)
    end, { expr = true, silent = true, desc = 'Codeium prev' })

    -- Manually trigger suggestion
    vim.keymap.set('i', '<M-\\>', function()
      return vim.fn['codeium#Complete']()
    end, { expr = true, silent = true, desc = 'Codeium trigger' })
  end,
}
