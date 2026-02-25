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
if vim.fn.has 'wsl' == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -NoProfile -Command Get-Clipboard',
      ['*'] = 'powershell.exe -NoProfile -Command Get-Clipboard',
    },
    cache_enabled = 0,
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
-- Remove Windows-style carriage returns (^M) automatically
vim.api.nvim_create_autocmd({ 'BufReadPost', 'TextChanged', 'TextChangedI' }, {
  pattern = '*',
  callback = function()
    vim.cmd [[silent! %s/\r//g]]
  end,
})
