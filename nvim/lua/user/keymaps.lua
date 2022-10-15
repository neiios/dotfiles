-- options used for most keymaps
local opts = { noremap = true, silent = true }
-- short set_keymap
local keymap = vim.api.nvim_set_keymap

-- space as a leader key
keymap('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- telescope bindings
keymap('n', '<leader>ff', ':Telescope find_files hidden=true<cr>', opts)
keymap('n', '<leader>fb', ':Telescope file_browser hidden=true<cr>', opts)
keymap(
  'n',
  '<leader>fs',
  ':Telescope current_buffer_fuzzy_find hidden=true<cr>',
  opts
)
-- nvim tree
keymap('n', '<leader>e', ':NvimTreeToggle<cr>', opts)

-- file save and quit
keymap('n', '<leader>w', ':w<cr>', opts)
keymap('n', '<leader>W', ':wa<cr>', opts)
keymap('n', '<leader>q', ':q<cr>', opts)
keymap('n', '<leader>Q', ':qa<cr>', opts)

-- easier window navigation
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- resize with arrows
keymap('n', '<C-Up>', ':resize +5<CR>', opts)
keymap('n', '<C-Down>', ':resize -5<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -5<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +5<CR>', opts)

-- navigate buffers
keymap('n', '<S-l>', ':bnext<CR>', opts)
keymap('n', '<S-h>', ':bprevious<CR>', opts)

-- stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- move text up and down
keymap('n', '<A-j>', ':m .+1<CR>==', opts)
keymap('n', '<A-k>', ':m .-2<CR>==', opts)
keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', opts)
keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', opts)
keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", opts)
keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", opts)
