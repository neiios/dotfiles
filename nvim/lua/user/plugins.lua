-- update plugins on file save
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
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

	if packer_bootstrap then
		require("packer").sync()
	end
end)
