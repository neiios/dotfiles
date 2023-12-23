{config, ...}: {
  programs.zsh = {
    initExtraBeforeCompInit = ''
      zmodload -i zsh/complist # Must be run before compinit
    '';
    enableCompletion = true; # Will run autoload -U compinit && compinit
    initExtra = ''
      autoload -U +X bashcompinit && bashcompinit

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

      # kdesrc-build #################################################################

      ## Add kdesrc-build to PATH
      export PATH="$HOME/Dev/kde/src/kdesrc-build:$PATH"

      ## Autocomplete for kdesrc-run
      function _comp_kdesrc_run
      {
        local cur
        COMPREPLY=()
        cur="''${COMP_WORDS [COMP_CWORD]}"

        # Complete only the first argument
        if [[ $COMP_CWORD != 1 ]]; then
          return 0
        fi

        # Retrieve build modules through kdesrc-run
        # If the exit status indicates failure, set the wordlist empty to avoid
        # unrelated messages.
        local modules
        if ! modules=$(kdesrc-run --list-installed);
        then
            modules=""
        fi

        # Return completions that match the current word
        COMPREPLY=( $(compgen -W "''${modules}" -- "$cur") )

        return 0
      }

      ## Register autocomplete function
      complete -o nospace -F _comp_kdesrc_run kdesrc-run
      ################################################################################

      # zsh parameter completion for the dotnet CLI
      _dotnet_zsh_complete()
      {
        local completions=("$(dotnet complete "$words")")

        # If the completion list is empty, just continue with filename selection
        if [ -z "$completions" ]
        then
          _arguments '*::arguments: _normal'
          return
        fi

        # This is not a variable assignment, don't remove spaces!
        _values = "''${(ps:\n:)completions}"
      }
    '';
  };
}
