-- C++ template setup function
local function setup_cpp_environment()
  -- Get the directory of the current file
  local current_dir = vim.fn.expand('%:p:h')
  local input_file = current_dir .. '/input.txt'
  local output_file = current_dir .. '/output.txt'
  
  -- Create input.txt if it doesn't exist
  if vim.fn.filereadable(input_file) == 0 then
    io.open(input_file, 'w'):close()
  end
  
  -- Create output.txt if it doesn't exist
  if vim.fn.filereadable(output_file) == 0 then
    io.open(output_file, 'w'):close()
  end
  
  -- Open input.txt and output.txt in right split
  vim.cmd 'vsplit'
  vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.2))
  vim.cmd('edit ' .. input_file)
  vim.cmd 'split'
  vim.cmd('edit ' .. output_file)
  -- Move to the main cpp window
  vim.cmd 'wincmd h'
  
  -- Set up keybindings for compilation and running
  local opts = { noremap = true, silent = true, buffer = true }
  vim.keymap.set('n', '<leader>cc', function()
    local dir = vim.fn.expand('%:p:h')
    local file = vim.fn.expand('%:p')
    
    -- Compile and capture errors to a temp file
    local error_file = dir .. '/.compile_errors.txt'
    local compile_cmd = 'cd ' .. dir .. ' && g++ -o ps.out ' .. file .. ' 2>' .. error_file .. ' 1>' .. error_file
    local compile_result = os.execute(compile_cmd)
    
    -- Clear previous diagnostics
    vim.diagnostic.reset(nil, vim.api.nvim_get_current_buf())
    
    -- Read and parse compiler output
    local error_handle = io.open(error_file, 'r')
    local diagnostics = {}
    
    if error_handle then
      local errors_exist = false
      for line in error_handle:lines() do
        errors_exist = true
        -- Parse g++ error format: file:line:column: error: message
        local filepath, line_num, col, msg = line:match('([^:]+):(%d+):(%d+): (.+)')
        if filepath and line_num and col then
          table.insert(diagnostics, {
            lnum = tonumber(line_num) - 1,
            col = tonumber(col) - 1,
            message = msg,
            severity = vim.diagnostic.severity.ERROR,
            source = 'g++',
          })
        end
      end
      error_handle:close()
      
      -- Display errors in terminal if they exist
      if errors_exist then
        -- Read error content
        local error_content = {}
        local read_handle = io.open(error_file, 'r')
        if read_handle then
          for line in read_handle:lines() do
            table.insert(error_content, line)
          end
          read_handle:close()
        end
        
        -- Create floating window for errors
        local width = math.min(100, vim.o.columns - 4)
        local height = math.min(#error_content + 2, vim.o.lines - 10)
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, error_content)
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        vim.api.nvim_buf_set_option(buf, 'filetype', 'cpp')
        
        local win = vim.api.nvim_open_win(buf, false, {
          relative = 'editor',
          width = width,
          height = height,
          row = vim.o.lines - height - 3,
          col = (vim.o.columns - width) / 2,
          style = 'minimal',
          border = 'rounded',
          title = ' Compilation Errors ',
          title_pos = 'center',
        })
        
        vim.api.nvim_win_set_option(win, 'winblend', 10)
        
        -- Set the errors as diagnostics for better visibility
        if #diagnostics > 0 then
          vim.diagnostic.set(vim.api.nvim_create_namespace('g++'), vim.fn.bufnr(file), diagnostics)
        end
        
        print('Compilation failed! Errors shown in floating window.')
      else
        -- No errors, run the program
        if compile_result == 0 then
          -- Run and redirect input/output
          local run_cmd = 'cd ' .. dir .. ' && ./ps.out < input.txt > output.txt'
          os.execute(run_cmd)
          
          -- Reload output.txt in the right panel
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local buf_name = vim.api.nvim_buf_get_name(buf)
            if buf_name:match('output.txt$') then
              vim.api.nvim_buf_call(buf, function()
                vim.cmd 'edit!'
              end)
            end
          end
          
          print('Compiled and ran successfully!')
        else
          print('Compilation failed!')
        end
      end
    end
    
    -- Clean up temp error file
    os.execute('rm -f ' .. error_file)
  end, opts)
end

-- C++ template for new files
vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = 'ps.cpp',
  callback = function()
    local template_path = vim.fn.stdpath 'config' .. '/templates/cpp.template'
    vim.cmd('read ' .. template_path)
    -- Move cursor to the end of while loop for editing
    vim.cmd 'normal! G'
    vim.cmd 'normal! 3k'
    vim.cmd 'normal! O'
    
    setup_cpp_environment()
  end,
})

-- Open ps.cpp with input and output layout when opening existing file
vim.api.nvim_create_autocmd('BufRead', {
  pattern = 'ps.cpp',
  callback = function()
    setup_cpp_environment()
  end,
})

