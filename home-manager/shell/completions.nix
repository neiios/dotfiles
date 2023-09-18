{config, ...}: {
  programs.zsh = {
    initExtraBeforeCompInit = ''
      zmodload -i zsh/complist # Must be run before compinit
    '';
    enableCompletion = true; # Will run autoload -U compinit && compinit
    initExtra = ''
      _comp_options+=(globdots) # Complete hidden files
      unsetopt complete_aliases
      zstyle ':completion:*' completer _extensions _complete _approximate

      zstyle ':completion:*' use-cache on # use completions cache
      zstyle ':completion:*' cache-path "${config.xdg.cacheHome}/zcompcache"

      zstyle ':completion:*' complete-options true # Autocomplete options for cd
      zstyle ':completion:*' file-sort modification # Sort files by modification

      zstyle ':completion:*' menu select
      zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
      zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
      zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
      zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
      zstyle ':completion:*:*:*:*:default' list-colors ''${(s.:.)LS_COLORS}

      zstyle ':completion:*' group-name '''
      zstyle ': completion:*:*:-command-:*:*' group-order alias builtins functions commands

      # I wont try to explain this
      zstyle ': completion:*' matcher-list ''' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      # Accept completion with ctrl+space
      bindkey '^ ' autosuggest-accept
    '';
  };
}
