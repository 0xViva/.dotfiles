return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '|', ':Neotree focus<CR>', desc = 'NeoTree reveal', silent = true },
    { '<Tab>', ':Neotree focus<CR>', desc = 'NeoTree focus (Escape key)', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        width = 10,
        auto_expand_width = true,
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
    event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function()
          vim.cmd 'setlocal relativenumber'
        end,
      },
    },
  },
}
