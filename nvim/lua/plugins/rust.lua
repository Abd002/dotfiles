-- Rust: rustaceanvim starts and configures rust-analyzer (do not also enable it in lsp.lua),
-- crates.nvim shows and updates crate versions inside Cargo.toml.
return {
  {
    'mrcjkb/rustaceanvim',
    version = '^9',
    lazy = false, -- the plugin is already lazy (filetype plugin)
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            local map = function(lhs, rhs, desc)
              vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = 'Rust: ' .. desc })
            end
            -- r: rust (only in Rust buffers)
            map('<leader>rr', function() vim.cmd.RustLsp 'runnables' end, 'Run (pick target)')
            map('<leader>rR', function() vim.cmd.RustLsp { 'runnables', bang = true } end, 'Re-run last')
            map('<leader>rt', function() vim.cmd.RustLsp 'testables' end, 'Test (pick test)')
            map('<leader>rT', function() vim.cmd.RustLsp { 'testables', bang = true } end, 'Re-run last test')
            map('<leader>rd', function() vim.cmd.RustLsp 'debuggables' end, 'Debug (pick target)')
            map('<leader>re', function() vim.cmd.RustLsp 'expandMacro' end, 'Expand macro')
            map('<leader>rc', function() vim.cmd.RustLsp 'openCargo' end, 'Open Cargo.toml')
            map('<leader>rp', function() vim.cmd.RustLsp 'parentModule' end, 'Parent module')
            map('<leader>rx', function() vim.cmd.RustLsp 'explainError' end, 'Explain error (rustc)')
            map('<leader>rD', function() vim.cmd.RustLsp 'renderDiagnostic' end, 'Full diagnostic (like cargo)')
            map('<leader>rj', function() vim.cmd.RustLsp 'joinLines' end, 'Join lines')
            map('<leader>rk', function() vim.cmd.RustLsp { 'moveItem', 'up' } end, 'Move item up')
            map('<leader>rJ', function() vim.cmd.RustLsp { 'moveItem', 'down' } end, 'Move item down')
            map('<leader>ca', function() vim.cmd.RustLsp 'codeAction' end, 'Code action (grouped)')
            map('K', function() vim.cmd.RustLsp { 'hover', 'actions' } end, 'Hover (with actions)')
          end,
          default_settings = {
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
      }
    end,
  },
  {
    'Saecki/crates.nvim',
    version = '^0.7',
    event = { 'BufRead Cargo.toml' },
    opts = {
      completion = { crates = { enabled = true } },
      lsp = { enabled = true, actions = true, completion = true, hover = true },
    },
    config = function(_, opts)
      local crates = require 'crates'
      crates.setup(opts)
      local function attach(buf)
        local map = function(lhs, rhs, desc)
          vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = 'Crates: ' .. desc })
        end
        map('<leader>rv', crates.show_versions_popup, 'Versions of crate')
        map('<leader>rf', crates.show_features_popup, 'Features of crate')
        map('<leader>ru', crates.upgrade_crate, 'Upgrade crate')
        map('<leader>rU', crates.upgrade_all_crates, 'Upgrade all crates')
        map('<leader>rh', crates.open_homepage, 'Open homepage')
        map('<leader>rs', crates.open_documentation, 'Open docs.rs')
      end
      -- this plugin loads when the first Cargo.toml opens, so attach to that buffer too
      if vim.fn.expand '%:t' == 'Cargo.toml' then attach(vim.api.nvim_get_current_buf()) end
      vim.api.nvim_create_autocmd('BufRead', {
        pattern = 'Cargo.toml',
        callback = function(ev) attach(ev.buf) end,
      })
    end,
  },
}
