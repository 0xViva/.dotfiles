return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,

  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'tsx',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'go',
        'templ',
        'css',
        'elixir',
      },
      ignore_install = {},
      sync_install = false,
      auto_install = true,
      modules = {},

      highlight = { enable = true },
      indent = { enable = true },
    }
  end,
}
