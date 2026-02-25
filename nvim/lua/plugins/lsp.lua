return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'williamboman/mason.nvim',
    opts = {},
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = {
        'clangd',
        'gopls',
        'html',
        'lua_ls',
        'ts_ls',
        'tailwindcss',
        'jdtls',
        'rust_analyzer',
      },
    },
  },
  { 'j-hui/fidget.nvim', opts = {} },
  { 'mfussenegger/nvim-jdtls' },
  { 'hrsh7th/cmp-nvim-lsp' },
  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = { source = 'if_many', spacing = 2 },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          local builtin = require 'telescope.builtin'
          map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
          map('gr', builtin.lsp_references, '[G]oto [R]eferences')
          map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
        end,
      })

      local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        clangd = {},
        gopls = {},
        html = { filetypes = { 'html', 'templ' } },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' },
              },
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        ts_ls = {},
        tailwindcss = {
          filetypes_include = { 'templ' },
          settings = { tailwindCSS = { includeLanguages = { templ = 'html' } } },
        },
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
              },
              checkOnSave = true,
              check = {
                command = 'clippy',
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      }

      for name, config in pairs(servers) do
        vim.lsp.config(name, vim.tbl_deep_extend('force', { capabilities = capabilities }, config))
        vim.lsp.enable(name)
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
          require('jdtls').start_or_attach {
            cmd = { 'jdtls' },
            root_dir = require('jdtls').setup.find_root { '.git', 'mvnw', 'gradlew' },
            capabilities = capabilities,
          }
        end,
      })
    end,
  },
}
