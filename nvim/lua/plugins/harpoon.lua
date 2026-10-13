return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup {}

    -- -- Use Telescope as a UI
    -- local conf = require('telescope.config').values
    -- local function toggle_telescope(harpoon_files)
    --   local file_paths = {}
    --   for _, item in ipairs(harpoon_files.items) do
    --     table.insert(file_paths, item.value)
    --   end
    --
    --   require('telescope.pickers')
    --     .new({}, {
    --       prompt_title = 'Harpoon',
    --       finder = require('telescope.finders').new_table {
    --         results = file_paths,
    --       },
    --       previewer = conf.file_previewer {},
    --       sorter = conf.generic_sorter {},
    --     })
    --     :find()
    -- end
    --
    -- vim.keymap.set('n', '<leader>M', function()
    --   toggle_telescope(harpoon:list())
    -- end, { desc = 'Open harpoon window' })

    -- Default UI
    local map = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = 'Harpoon: ' .. desc }) end
    -- h: harpoon (pin up to 4 files per project, jump to them instantly)
    map('<leader>ha', function() harpoon:list():add() end, 'Pin this file')
    map('<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, 'Menu (reorder / remove)')
    map('<leader>hn', function() harpoon:list():next() end, 'Next pinned file')
    map('<leader>hp', function() harpoon:list():prev() end, 'Previous pinned file')
    for i = 1, 4 do
      map('<leader>' .. i, function() harpoon:list():select(i) end, 'Go to pinned file ' .. i)
    end
  end,
}
