-- telescope configuration
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<C-h>'] = 'which_key',
      },
    },
    file_ignore_patterns = { '.git', '.cache', 'node_modules' },
  },
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')
