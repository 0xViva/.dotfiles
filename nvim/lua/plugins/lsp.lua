return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      { 'j-hui/fidget.nvim', opts = {} },
      'mfussenegger/nvim-jdtls',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', function()
            require('telescope.builtin').lsp_definitions()
          end, '[G]oto [D]efinition')
          map('gr', function()
            require('telescope.builtin').lsp_references()
          end, '[G]oto [R]eferences')
          map('gI', function()
            require('telescope.builtin').lsp_implementations()
          end, '[G]oto [I]mplementation')

          map('<leader>D', function()
            require('telescope.builtin').lsp_type_definitions()
          end, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', function()
            require('telescope.builtin').lsp_document_symbols()
          end, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', function()
            require('telescope.builtin').lsp_dynamic_workspace_symbols()
          end, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })
      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        clangd = {},
        cmake = {}, -- kept as 'cmake'
        cssls = {}, -- css-lsp
        css_variables = {}, -- css-variables-language-server
        gopls = {},
        html = {
          filetypes = { 'html', 'templ' },
        },
        htmx = {
          filetypes = { 'html', 'templ' },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        rust_analyzer = {},
        tailwindcss = {
          filetypes_exclude = { 'markdown' },
          filetypes_include = { 'templ' }, -- add any extras you want
          settings = {
            tailwindCSS = {
              includeLanguages = {
                templ = 'html',
                elixir = 'html-eex',
                eelixir = 'html-eex',
                heex = 'html-eex',
              },
            },
          },
        },
        templ = {},
        ts_ls = {},
        jdtls = {
          on_attach = function(client, bufnr)
            -- Setup keymaps etc. if needed
            require('java').setup {}

            -- NOTE: jdtls uses its own start_or_attach; prevent double setup
          end,
          setup = function()
            local jdtls = require 'jdtls'
            local lspconfig = require 'lspconfig'
            local opts = {
              cmd = lspconfig.jdtls.document_config.default_config.cmd,
              root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew' },
            }

            vim.api.nvim_create_autocmd('FileType', {
              pattern = 'java',
              callback = function()
                jdtls.start_or_attach(opts)
              end,
            })
          end,
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Lua formatter
        'prettier', -- JavaScript/TypeScript formatter
        'prettierd', -- Faster prettier daemon formatter
        'google-java-format',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      local function setup_tailwindcss(_, opts)
        opts.filetypes = opts.filetypes or {}

        -- Add default Tailwind filetypes (from lspconfig)
        local default_ft = require('lspconfig.server_configurations.tailwindcss').default_config.filetypes
        vim.list_extend(opts.filetypes, default_ft)

        -- Remove excluded
        opts.filetypes = vim.tbl_filter(function(ft)
          return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
        end, opts.filetypes)

        -- Add any additional includes
        vim.list_extend(opts.filetypes, opts.filetypes_include or {})
      end
      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = true,
        handlers = {
          -- Default handler (for all servers)
          function(server_name)
            local server_opts = servers[server_name] or {}
            server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})

            if server_name == 'tailwindcss' then
              setup_tailwindcss(server_name, server_opts)
            end

            if server_name == 'jdtls' and server_opts.setup then
              server_opts.setup() -- Use nvim-jdtls logic
            end

            -- Use new API if available (Neovim >= 0.11)
            if vim.lsp.config and vim.lsp.enable then
              print 'vim.lsp.config ok'
              -- Create a table with server_name as key
              local config_table = {}
              config_table[server_name] = server_opts
              vim.lsp.config(config_table)
              vim.lsp.enable(server_name)
            else
              -- Fallback for old Neovim
              local ok, lspconfig = pcall(require, 'lspconfig')
              print 'fell back...'
              if ok then
                lspconfig[server_name].setup(server_opts)
              end
            end
          end,
        },
      }
    end,
  },
}
