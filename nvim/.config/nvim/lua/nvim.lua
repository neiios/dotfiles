require('user.plugins')
-- initialize plugins
require('user.treesitter')
require('user.keymaps')
require('user.telescope')
require('user.autopair')
require('user.comment')
require('user.lsp')
require('user.nvim-cmp')
require('user.nvim-tree')
require('user.nvim-surround')

vim.o.background = 'dark'
vim.opt.signcolumn = 'yes' -- always show sign column

if vim.fn.has('termguicolors') then
  vim.opt.termguicolors = true
  require('user.colorscheme')
end
