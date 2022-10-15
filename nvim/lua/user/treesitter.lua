-- treesitter configuration
require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  sync_install = false,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  incremental_selection = { enable = true },
  indent = { enable = true },
  matchup = { enable = true },
})

-- zsh currently has no parser, but bash parser generally has good support for it
local ft_to_lang = require('nvim-treesitter.parsers').ft_to_lang
require('nvim-treesitter.parsers').ft_to_lang = function(ft)
  if ft == 'zsh' then
    return 'bash'
  end
  return ft_to_lang(ft)
end
