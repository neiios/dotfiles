-- Space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

vim.pack.add({
  {src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main"},
  {src = "https://github.com/nvim-lua/plenary.nvim"},
  {src = "https://github.com/nvim-telescope/telescope.nvim", version = "master"},
  {src = 'https://github.com/neovim/nvim-lspconfig'},
  {src = 'https://github.com/miikanissi/modus-themes.nvim'},
  {src = "https://github.com/Saghen/blink.cmp"},
})

require("modus-themes").setup({
	transparent = true,
	line_nr_column_background = false,
	sign_column_background = false,
})


vim.cmd([[colorscheme modus]])

-- Create an event to build `blink.cmp` with `cargo build --release`.
-- This event should be defined *before* the `vim.pack.add` call
-- so it runs automatically after the plugin is installed.
vim.api.nvim_create_autocmd("PackChanged", {
  pattern = "blink.cmp",
  group = vim.api.nvim_create_augroup("blink_update", { clear = true }),
  callback = function(e)
    if e.data.kind == "update" then
      -- Recommended way to access plugin files inside `PackChanged` event
      -- vim.cmd [[packadd blink.cmp]]
      vim.cmd.packadd({ args = { e.data.spec.name }, bang = false })
      -- Build the plugin from source
      -- vim.cmd [[BlinkCmp build]]
      require("blink.cmp.fuzzy.build").build()
    end
  end,
})

-- Plugin setup
require("blink.cmp").setup({
  keymap = {
    ["<C-n>"] = { "show_and_insert", "select_next" },
    ["<C-p>"] = { "show_and_insert", "select_prev" },
    ["<C-j>"] = { "select_and_accept" },
  },
})

treesitter_enabled_languages = {'bash', 'dockerfile', 'lua', 'go'}

require('nvim-treesitter').install(treesitter_enabled_languages)

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("hi! Normal guibg=NONE ctermbg=NONE")
    vim.cmd("hi! NonText guibg=NONE ctermbg=NONE")
  end,
})

vim.api.nvim_create_autocmd('filetype', {
  pattern = treesitter_enabled_languages,
  callback = function() vim.treesitter.start() end,
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

vim.lsp.enable({'lua_ls', 'gopls'})

