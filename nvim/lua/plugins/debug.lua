return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  keys = {
    {
      '<F5>',
      function() require('dap').continue() end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function() require('dap').step_into() end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function() require('dap').step_over() end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function() require('dap').step_out() end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function() require('dap').toggle_breakpoint() end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
      desc = 'Debug: Set Breakpoint',
    },
    {
      '<F7>',
      function() require('dapui').toggle() end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',
        'codelldb', -- for Rust
      },
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Go
    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Rust
    local mason_path = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/'
    local codelldb_path = mason_path .. 'adapter/codelldb'
    local liblldb_path = mason_path .. 'lldb/lib/liblldb'
        .. (vim.fn.has('mac') == 1 and '.dylib' or '.so')

    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = codelldb_path,
        args = { '--liblldb', liblldb_path, '--port', '${port}' },
      },
    }

    dap.configurations.rust = {
      {
        name = 'Launch',
        type = 'codelldb',
        request = 'launch',
        program = function()
          local result = vim.fn.systemlist(
            'find ' .. vim.fn.getcwd() .. '/target/debug -maxdepth 1 -type f -executable'
          )
          if #result == 0 then
            vim.notify('No executables found — run cargo build first', vim.log.levels.ERROR)
            return dap.ABORT
          end
          local co = coroutine.running()
          vim.ui.select(result, { prompt = 'Select binary:' }, function(choice)
            coroutine.resume(co, choice)
          end)
          return coroutine.yield()
        end,
      },
    }
  end,
}
