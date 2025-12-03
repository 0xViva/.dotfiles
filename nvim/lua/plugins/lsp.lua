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
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'mfussenegger/nvim-jdtls',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Diagnostics config
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(d)
            return d.message
          end,
        },
      }

      -- LSP keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
        callback = function(event)
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
          map('<leader>ds', function()
            require('telescope.builtin').lsp_document_symbols()
          end, '[D]ocument [S]ymbols')
          map('<leader>ws', function()
            require('telescope.builtin').lsp_dynamic_workspace_symbols()
          end, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method 'textDocument/documentHighlight' then
            local hl_augroup = vim.api.nvim_create_augroup('lsp_highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = hl_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = hl_augroup,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- LSP servers
      local servers = {
        clangd = {},
        cmake = {},
        cssls = {},
        css_variables = {},
        gopls = {},
        html = { filetypes = { 'html', 'templ' } },
        htmx = { filetypes = { 'html', 'templ' } },
        lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
        rust_analyzer = {},
        tailwindcss = {
          filetypes_exclude = { 'markdown' },
          filetypes_include = { 'templ' },
          settings = {
            tailwindCSS = {
              includeLanguages = { templ = 'html', elixir = 'html-eex', eelixir = 'html-eex', heex = 'html-eex' },
            },
          },
        },
        templ = {},
        ts_ls = {},
        jsonls = {},
        gradle_ls = {},
      }

      -- Ensure Mason installs the servers
      require('mason-tool-installer').setup { ensure_installed = vim.tbl_keys(servers) }

      -- Mason-lspconfig setup
      require('mason-lspconfig').setup { ensure_installed = vim.tbl_keys(servers), automatic_installation = true }

      -- Attach servers using new API
      for name, opts in pairs(servers) do
        opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, opts.capabilities or {})
        if vim.lsp.config and vim.lsp.enable then
          vim.lsp.config(name, opts)
          vim.lsp.enable(name)
        else
          require('lspconfig')[name].setup(opts)
        end
      end

      -- Java LSP (jdtls) special
      local jdtls = require 'jdtls'
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
          jdtls.start_or_attach {
            cmd = { 'java-lsp.sh' }, -- or your existing cmd
            root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew' },
          }
        end,
      })
    end,
  },
}
