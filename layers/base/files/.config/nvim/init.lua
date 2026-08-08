vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.relativenumber = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.inccommand = "split"

vim.o.splitright = true
vim.o.splitbelow = true
vim.opt.diffopt:append("vertical")

vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevelstart = 99

local augroup = vim.api.nvim_create_augroup("init", {})

vim.api.nvim_create_autocmd({ "TextYankPost", "TextPutPost" }, {
  group = augroup,
  callback = function()
    vim.hl.hl_op()
  end,
})

vim.diagnostic.config({ virtual_text = true })

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "master" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/miikanissi/modus-themes.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/refractalize/oil-git-status.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/NeogitOrg/neogit" },
  { src = "https://github.com/rickhowe/wrapwidth" },
})

require("modus-themes").setup({
  transparent = true,
  line_nr_column_background = false,
  sign_column_background = false,
})
vim.cmd.colorscheme("modus")

vim.o.autocomplete = true
vim.o.complete = "o,."
vim.o.completeopt = "menuone,noselect,fuzzy"

local ts_dir = vim.pack.get({ "nvim-treesitter" }, { info = false })[1].path
vim.opt.runtimepath:prepend(vim.fs.joinpath(ts_dir, "runtime"))

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if lang and vim.treesitter.language.add(lang) then
      vim.treesitter.start(ev.buf, lang)
    end
  end,
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Telescope resume" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope diagnostics" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope recent files" })
vim.keymap.set(
  "n",
  "<leader>fw",
  builtin.grep_string,
  { desc = "Telescope grep word under cursor" }
)

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>gq", function()
  if vim.b.wrapwidth then
    vim.cmd.Wrapwidth(0)
    vim.wo.linebreak = false
  else
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.cmd.Wrapwidth(80)
  end
end, { desc = "Toggle visual wrap at 80 chars" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "help", "fugitive", "git" },
  command = "wincmd L",
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      hints = {
        parameterNames = true,
        assignVariableTypes = true,
        compositeLiteralFields = true,
      },
    },
  },
})

vim.lsp.enable({ "lua_ls", "gopls", "stylua" })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*.lua",
  callback = function(ev)
    if next(vim.lsp.get_clients({ bufnr = ev.buf, name = "stylua" })) then
      vim.lsp.buf.format({ bufnr = ev.buf, name = "stylua", timeout_ms = 2000 })
    end
  end,
})

require("oil").setup({
  win_options = {
    signcolumn = "yes:2",
  },
  view_options = {
    show_hidden = true,
  },
})
require("oil-git-status").setup()
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })

require("neogit").setup({})
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Show Neogit UI" })

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Next hunk" })

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Previous hunk" })

    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage hunk" })

    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset hunk" })

    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
    map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
    map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

    map("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end, { desc = "Blame line" })

    map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })

    map("n", "<leader>hD", function()
      gitsigns.diffthis("~")
    end, { desc = "Diff this against last commit" })

    map("n", "<leader>hq", gitsigns.setqflist, { desc = "Hunks to quickfix" })
    map("n", "<leader>hQ", function()
      gitsigns.setqflist("all")
    end, { desc = "All hunks to quickfix" })

    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
    map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

    map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select hunk" })
  end,
})
