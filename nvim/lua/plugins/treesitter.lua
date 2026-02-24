return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,

  config = function()
    require("nvim-treesitter").setup()

    local parsers = {
      "latex", "bash", "c", "diff", "tsx", "html", "lua", "luadoc",
      "markdown", "markdown_inline", "query", "vim", "vimdoc",
      "go", "templ", "css", "elixir",
    }

    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
