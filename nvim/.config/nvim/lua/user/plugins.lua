local status, packer = pcall(require, "packer")
if not status then
	print("Packer is not installed")
	return
end

vim.cmd([[packadd packer.nvim]])

-- update plugins on file save
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

packer.startup(function(use)
	-- package manager
	use("wbthomason/packer.nvim")

	-- theme
	use("jacoborus/tender.vim")
	use({ "mcchrish/zenbones.nvim", requires = "rktjmp/lush.nvim" })
	use("wuelnerdotexe/vim-enfocado")

	-- native lsp
	use("neovim/nvim-lspconfig")

	-- completions
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	-- for luasnip
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("rafamadriz/friendly-snippets")

	-- nvim-tree
	use("kyazdani42/nvim-tree.lua")

	-- null ls
	use("jose-elias-alvarez/null-ls.nvim")

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})

	-- telescope things
	use("nvim-telescope/telescope.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("nvim-telescope/telescope-file-browser.nvim")
	use("kyazdani42/nvim-web-devicons")

	-- misc
	use("windwp/nvim-autopairs")
	use("kylechui/nvim-surround")
	use("tpope/vim-repeat")
	use("numToStr/Comment.nvim")

	-- deps
	use("nvim-lua/plenary.nvim")
	use("nvim-lua/popup.nvim")
end)
