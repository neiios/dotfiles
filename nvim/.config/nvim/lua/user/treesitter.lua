local status, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not status then
  return
end

-- treesitter configuration
treesitter_configs.setup({
  ensure_installed = 'all',
  sync_install = false,
  auto_install = true,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  incremental_selection = { enable = true },
  indent = { enable = true },
  matchup = { enable = true },
})

local status, treesitter_parsers = pcall(require, 'nvim-treesitter.parsers')
if not status then
  return
end

-- zsh currently has no parser, but bash parser generally has good support for it
local ft_to_lang = treesitter_parsers.ft_to_lang
require('nvim-treesitter.parsers').ft_to_lang = function(ft)
  if ft == 'zsh' then
    return 'bash'
  end
  return ft_to_lang(ft)
end
