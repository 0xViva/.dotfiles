return {
  {
    'rose-pine/neovim',
    priority = 1000,
    config = function()

      require('rose-pine').setup {
        variant = 'auto',
        dark_variant = 'main',
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        disable_background = true,

        enable = {
          terminal = true,
          legacy_highlights = true,
          migrations = true,
        },

        styles = {
          bold = true,
          italic = true,
          transparency = false,
        },

        groups = {
          border = 'muted',
          link = 'iris',
          panel = 'surface',

          error = 'love',
          hint = 'iris',
          info = 'foam',
          note = 'pine',
          todo = 'rose',
          warn = 'gold',

          git_add = 'foam',
          git_change = 'rose',
          git_delete = 'love',
          git_dirty = 'rose',
          git_ignore = 'muted',
          git_merge = 'iris',
          git_rename = 'pine',
          git_stage = 'iris',
          git_text = 'rose',
          git_untracked = 'subtle',

          h1 = 'iris',
          h2 = 'foam',
          h3 = 'rose',
          h4 = 'gold',
          h5 = 'pine',
          h6 = 'foam',
        },

        palette = {

        },

        highlight_groups = {

        },

        before_highlight = function(group, highlight, palette)

        end,
      }

      vim.cmd 'colorscheme rose-pine'

    end,
  },

  {
    -- Provides `base16-colorscheme`, applied by the Noctalia-generated module
    -- ~/.config/nvim/lua/matugen.lua. The "matugen" name is inherited from the
    -- template ecosystem; matugen itself is not installed - Noctalia renders
    -- this file from its palette. Loaded after rose-pine so the Noctalia palette
    -- wins when the file exists, and rose-pine stays the fallback if it has not
    -- been rendered yet.
    'RRethy/base16-nvim',
    config = function()
      local ok, matugen = pcall(require, 'matugen')
      if ok then matugen.setup() end
    end,
  },
}
