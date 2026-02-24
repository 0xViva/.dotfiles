return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,

  config = function()
    require("nvim-treesitter").setup()

    require("nvim-treesitter").install({
      "latex", "bash", "c", "diff", "tsx", "html", "lua", "luadoc",
      "markdown", "markdown_inline", "query", "vim", "vimdoc",
      "go", "templ", "css", "elixir",
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { '<filetype>' },
      callback = function() vim.treesitter.start() end,
    })
  end,
}
