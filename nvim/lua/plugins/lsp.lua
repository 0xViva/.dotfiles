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
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim',       opts = {} },
      'mfussenegger/nvim-jdtls',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- 1. Setup UI & Diagnostics
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = { source = 'if_many', spacing = 2 },
      })

      -- 2. Define Keymaps for when an LSP attaches
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local builtin = require('telescope.builtin')
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

      -- 3. Prepare Capabilities (Broadcasting what features we support to the LSP)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- 4. Server Settings Table
      local servers = {
        clangd = {},
        gopls = {},
        html = { filetypes = { 'html', 'templ' } },
        lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
        rust_analyzer = {},
        ts_ls = {},
        tailwindcss = {
          filetypes_include = { 'templ' },
          settings = { tailwindCSS = { includeLanguages = { templ = 'html' } } },
        },
        jdtls = {},

      }

      -- 5. Mason Setup
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          -- Default handler for most servers
          function(server_name)
            -- Skip jdtls here! We handle it via an Autocmd/nvim-jdtls
            if server_name == "jdtls" then return end

            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })

      -- 6. Dedicated JDTLS Setup (Required for Java)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
          local jdtls = require('jdtls')

          -- Config for the server
          local config = {
            cmd = { 'jdtls' }, -- Mason installs the 'jdtls' binary to your path
            root_dir = jdtls.setup.find_root({ '.git', 'mvnw', 'gradlew' }),
            capabilities = capabilities,
          }

          -- Start or attach
          jdtls.start_or_attach(config)
        end,
      })
    end,
  },
}
