vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.opt.guicursor = ''
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '80'
vim.opt.termguicolors = true
vim.opt.mouse = ''
vim.opt.showmode = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.laststatus = 3
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.confirm = true
vim.opt.isfname:append '@-@'
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 10
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Clipboard. Setting 'clipboard' disables Neovim's own OSC 52 fallback (see
-- provider/clipboard.vim), so the provider is chosen explicitly here.
--
-- Inside tmux the copy path goes through tmux: `load-buffer -w` stores the text
-- in a tmux paste buffer and pushes it to the terminal clipboard over OSC 52
-- (so it survives ssh and is shared with tmux's own copy mode). Paste reads
-- tmux's newest paste buffer with `save-buffer`, which therefore contains every
-- copy made by any program inside tmux. It cannot contain text copied outside
-- tmux: tmux never returns an OSC 52 read reply to a pane, and its
-- `refresh-client -l` query cannot be relied on (Ghostty 1.3.1 answers it only
-- intermittently). Use the terminal's own paste for that.
--
-- Outside tmux (e.g. a direct ssh session) OSC 52 works both ways.
local function env_is_set(name)
  local value = os.getenv(name)
  return value ~= nil and value ~= ''
end

if env_is_set 'TMUX' and vim.fn.executable 'tmux' == 1 then
  local copy = { 'tmux', 'load-buffer', '-w', '-' }
  local paste = { 'tmux', 'save-buffer', '-' }
  vim.g.clipboard = {
    name = 'tmux',
    copy = {
      ['+'] = copy,
      ['*'] = copy,
    },
    paste = {
      ['+'] = paste,
      ['*'] = paste,
    },
  }
elseif env_is_set 'SSH_TTY' then
  local osc52 = require 'vim.ui.clipboard.osc52'
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = osc52.copy '+',
      ['*'] = osc52.copy '*',
    },
    paste = {
      ['+'] = osc52.paste '+',
      ['*'] = osc52.paste '*',
    },
  }
end

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww $HOME/.dotfiles/bin/tmux-sessionizer<CR>')
vim.keymap.set('n', '<leader>tf', function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat

  if vim.b.disable_autoformat then
    vim.notify('Autoformat disabled (buffer)', vim.log.levels.INFO)
  else
    vim.notify('Autoformat enabled (buffer)', vim.log.levels.INFO)
  end
end, { desc = 'Toggle autoformat (buffer)' })
vim.keymap.set('n', '<leader>tF', function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat

  if vim.g.disable_autoformat then
    vim.notify('Autoformat disabled (global)', vim.log.levels.INFO)
  else
    vim.notify('Autoformat enabled (global)', vim.log.levels.INFO)
  end
end, { desc = 'Toggle autoformat (global)' })
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
vim.keymap.set('n', 'q', function()
  vim.diagnostic.setloclist()
  local items = vim.fn.getloclist(0)

  if vim.tbl_isempty(items) then
    vim.cmd 'lclose'
    return
  end
  vim.cmd 'lopen'
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local info = vim.fn.getwininfo(win)[1]
    if info.loclist == 1 then
      vim.api.nvim_set_current_win(win)
      break
    end
  end
end, { desc = 'Open and focus diagnostic [Q]uickfix list, auto-close if empty' })
vim.api.nvim_set_keymap('i', '<CapsLock>', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<CapsLock>', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<CapsLock>', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
