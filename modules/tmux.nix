{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.tmux;
in {
  options.modules.tmux = {
    enable = lib.mkEnableOption "TMux";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      prefix = "C-a";

      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      customPaneNavigationAndResize = true;
      disableConfirmationPrompt = true;
      escapeTime = 0;
      historyLimit = 50000;
      keyMode = "vi";
      mouse = true;

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-dir '$HOME/.config/tmux/ressurect'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '5'
          '';
        }
        tmuxPlugins.mode-indicator
        tmuxPlugins.yank
      ];

      extraConfig = ''
        # tmux messages are displayed indefinitelly
        set -g display-time 0
        # helps with autoread inside vim
        set-option -g focus-events on

        # customize status bar
        set -g status-bg black
        set -g status-fg green
        set -g status-justify centre
        set -g status-left-length 20
        set-window-option -g status-left "#[fg=black,bg=cyan] #S "
        set -g status-right-length 20
        set -g status-right "#{tmux_mode_indicator}"
        set-window-option -g window-status-current-format "#[fg=black,bg=green] #I:#W "

        # reload config file
        bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
        # create splits
        bind-key v split-window -h -c "#{pane_current_path}"
        bind-key s split-window -v -c "#{pane_current_path}"
        # resize panes (press prefix, hold ctrl and press key multiple times)
        bind-key -r C-j resize-pane -D 5
        bind-key -r C-k resize-pane -U 5
        bind-key -r C-h resize-pane -L 5
        bind-key -r C-l resize-pane -R 5
        # navigate panes
        bind -r h select-pane -L
        bind -r j select-pane -D
        bind -r k select-pane -U
        bind -r l select-pane -R
        # block selection in copy mode
        bind-key -Tcopy-mode-vi 'v' send -X begin-selection
        # move windows
        bind-key -n C-S-Left swap-window -t -1\; select-window -t -1
        bind-key -n C-S-Right swap-window -t +1\; select-window -t +1
      '';
    };

    programs.zsh.initExtra = ''
      # Autolaunch tmux in gnome console
      term_name="$(basename "/"$(ps -o cmd -f -p $(cat /proc/$(echo $$)/stat | cut -d \  -f 4) | tail -1 | sed 's/ .*$//'))"
      if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ "$term_name" == "foot" ]] && [ -z "$TMUX" ]; then
        tmux attach || tmux >/dev/null 2>&1
      fi
    '';
  };
}
