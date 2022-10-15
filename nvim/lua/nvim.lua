require("user.plugins")
-- initialize plugins

require("user.treesitter")
require("user.keymaps")
require("user.telescope")
require("user.autopair")
require("user.comment")
require("user.lsp")
require("user.nvim-cmp")
require("user.nvim-tree")
require("user.nvim-surround")

-- colorscheme
if vim.fn.has("termguicolors") then
	vim.cmd("syntax off") -- disable standard vim syntax highlighting
	vim.opt.termguicolors = true
	vim.g.enfocado_style = "nature"
	vim.cmd("colorscheme enfocado")
end

vim.o.background = "dark"
vim.opt.signcolumn = "yes" -- always show sign column
