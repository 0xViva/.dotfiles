return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,

  config = function()
    require('nvim-treesitter').setup()

    local languages = {
      'bash', 'c', 'diff', 'tsx', 'html', 'lua', 'luadoc', 'markdown',
      'markdown_inline', 'query', 'vim', 'vimdoc', 'go', 'templ', 'css', 'elixir',
    }


    require('nvim-treesitter').install(languages)

    local filetypes = {}
    for _, lang in ipairs(languages) do
      for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
        table.insert(filetypes, ft)
      end
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = filetypes,
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
