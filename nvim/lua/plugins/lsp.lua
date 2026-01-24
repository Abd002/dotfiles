return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'mason-org/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    -- mason-lspconfig:
    -- - Bridges the gap between LSP config names (e.g. "lua_ls") and actual Mason package names (e.g. "lua-language-server").
    -- - Used here only to allow specifying language servers by their LSP name (like "lua_ls") in `ensure_installed`.
    -- - It does not auto-configure servers — we use vim.lsp.config() + vim.lsp.enable() explicitly for full control.
    'mason-org/mason-lspconfig.nvim',
    -- mason-tool-installer:
    -- - Installs LSPs, linters, formatters, etc. by their Mason package name.
    -- - We use it to ensure all desired tools are present.
    -- - The `ensure_installed` list works with mason-lspconfig to resolve LSP names like "lua_ls".
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    {
      'j-hui/fidget.nvim',
      opts = {
        notification = {
          window = {
            winblend = 0, -- Background color opacity in the notification window
          },
        },
      },
    },

    -- Allows extra capabilities provided by nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      -- Create a function that lets us more easily define mappings specific LSP related items.
      -- It sets the mode, buffer and description for us each time.
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-T>.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace
        --  Similar to document symbols, except searches over your whole project.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- Rename the variable under your cursor
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        map('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end

        -- Enable formatting for Rust files with rust_analyzer
        if client and client.name == 'rust_analyzer' then
          local augroup = vim.api.nvim_create_augroup('rust_format', { clear = false })
          vim.api.nvim_clear_autocmds { group = augroup, buffer = event.buf }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = event.buf,
            callback = function()
              vim.lsp.buf.format {
                bufnr = event.buf,
                async = false,
                timeout_ms = 5000,
              }
            end,
          })
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    -- By default, Neovim doesn't support everything that is in the LSP specification.
    -- When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    -- So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Enable the following language servers
    --
    -- Add any additional override configuration in the following tables. Available keys are:
    -- - cmd (table): Override the default command used to start the server
    -- - filetypes (table): Override the default list of associated filetypes for the server
    -- - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    -- - settings (table): Override the default settings passed when initializing the server.
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file('', true),
            },
            diagnostics = {
              globals = { 'vim' },
              disable = { 'missing-fields' },
            },
            format = {
              enable = false,
            },
          },
        },
      },
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              pyflakes = { enabled = false },
              pycodestyle = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              mccabe = { enabled = false },
              pylsp_mypy = { enabled = false },
              pylsp_black = { enabled = false },
              pylsp_isort = { enabled = false },
            },
          },
        },
      },
      rust_analyzer = {
        settings = {
          ['rust-analyzer'] = {
            -- Cargo settings
            cargo = {
              allFeatures = true,
              allTargets = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Check/Clippy settings
            check = {
              command = 'clippy',
              extraArgs = { '--all-targets', '--all-features' },
            },
            checkOnSave = true,
            
            -- Inlay hints (annotations)
            inlayHints = {
              enable = true,
              closureReturnTypeHints = {
                enable = 'with_block',
              },
              lifetimeElisionHints = {
                enable = true,
                useParameterNames = true,
              },
              reborrowHints = {
                enable = true,
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
              chainingHints = {
                enable = true,
              },
              bindingModeHints = {
                enable = true,
              },
              implicitDrops = {
                enable = true,
              },
            },
            
            -- Hover documentation
            hover = {
              documentation = {
                enable = true,
              },
              actions = {
                enable = true,
                implementations = {
                  enable = true,
                },
                references = {
                  enable = true,
                },
                run = {
                  enable = true,
                },
              },
            },
            
            -- Diagnostics
            diagnostics = {
              enable = true,
              disabled = {},
              warningsAsHint = {},
              warningsAsInfo = {},
            },
            
            -- Code lenses
            lens = {
              enable = true,
              debug = {
                enable = true,
              },
              forceCustomCommands = true,
              implementations = {
                enable = true,
              },
              references = {
                adt = {
                  enable = true,
                },
                enumVariant = {
                  enable = true,
                },
                method = {
                  enable = true,
                },
                trait = {
                  enable = true,
                },
              },
              run = {
                enable = true,
              },
            },
            
            -- Semantic tokens (syntax highlighting)
            semanticTokens = {
              enable = true,
            },
            
            -- Completion
            completion = {
              callable = {
                snippets = 'fill_arguments',
              },
              privateEditable = {
                enable = false,
              },
              postfix = {
                enable = true,
              },
              snippets = {
                custom = {
                  Arc = {
                    postfix = 'arc',
                    body = 'Arc::new(${receiver})',
                    requires = 'std::sync::Arc',
                    description = 'Put the expression in an `Arc`',
                    scope = 'expr',
                  },
                  Box = {
                    postfix = 'box',
                    body = 'Box::new(${receiver})',
                    requires = 'std::boxed::Box',
                    description = 'Put the expression in a `Box`',
                    scope = 'expr',
                  },
                  Ok = {
                    postfix = 'ok',
                    body = 'Ok(${receiver})',
                    description = 'Wrap the expression in a `Result::Ok`',
                    scope = 'expr',
                  },
                  Err = {
                    postfix = 'err',
                    body = 'Err(${receiver})',
                    description = 'Wrap the expression in a `Result::Err`',
                    scope = 'expr',
                  },
                  Some = {
                    postfix = 'some',
                    body = 'Some(${receiver})',
                    description = 'Wrap the expression in an `Option::Some`',
                    scope = 'expr',
                  },
                },
              },
            },
            
            -- Imports
            imports = {
              granularity = {
                enforce = false,
              },
              group = {
                enable = true,
              },
              merge = {
                glob = true,
              },
              prefix = 'crate',
            },
            
            -- File operations
            files = {
              excludeDirs = { '.cargo', '.git', '.github', '.rust-analyzer', '.vscode', 'target' },
              watcher = 'client',
            },
            
            -- Proc macros
            procMacro = {
              enable = true,
            },
            
            -- Macro expansion
            expandMacros = {
              enable = true,
            },
          },
        },
      },
      -- basedpyright = {
      --   -- Config options: https://github.com/DetachHead/basedpyright/blob/main/docs/settings.md
      --   settings = {
      --     basedpyright = {
      --       disableOrganizeImports = true, -- Using Ruff's import organizer
      --       disableLanguageServices = false,
      --       analysis = {
      --         ignore = { '*' },                 -- Ignore all files for analysis to exclusively use Ruff for linting
      --         typeCheckingMode = 'off',
      --         diagnosticMode = 'openFilesOnly', -- Only analyze open files
      --         useLibraryCodeForTypes = true,
      --         autoImportCompletions = true,     -- whether pyright offers auto-import completions
      --       },
      --     },
      --   },
      -- },
      ruff = {},
      jsonls = {},
      sqlls = {},
      terraformls = {},
      yamlls = {},
      bashls = {},
      dockerls = {},
      docker_compose_language_service = {},
      -- tailwindcss = {},
      -- graphql = {},
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      -- cssls = {},
      -- ltex = {},
      -- texlab = {},
      clangd = {
        settings = {
          clangd = {
            InlayHints = {
              Enabled = true,
              ParameterHints = true,
              TypeHints = true,
              ChainingHints = true,
            },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    for server, cfg in pairs(servers) do
      -- For each LSP server (cfg), we merge:
      -- 1. A fresh empty table (to avoid mutating capabilities globally)
      -- 2. Your capabilities object with Neovim + cmp features
      -- 3. Any server-specific cfg.capabilities if defined in `servers`
      cfg.capabilities = vim.tbl_deep_extend('force', {}, capabilities, cfg.capabilities or {})

      vim.lsp.config(server, cfg)
      vim.lsp.enable(server)
    end
  end,
}
