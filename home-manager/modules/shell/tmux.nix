{ pkgs, ... }:
let
  tmux-session-wizard = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-session-wizard";
    rtpFilePath = "session-wizard.tmux";
    version = "v1.2.0";
    src = pkgs.fetchFromGitHub {
      owner = "27medkamal";
      repo = "tmux-session-wizard";
      rev = "e9aac710119308d8dc4088667fd477883ff375e4";
      sha256 = "IfSgX02vXdpzyu1GRF1EvzVCqqOEiTjeXtl1EvNr7EI=";
    };
  };
in
{
  # Needed for tmux-session-wizard
  programs.zoxide.enable = true;

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    prefix = "M-a";
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    disableConfirmationPrompt = true;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      mode-indicator
      yank
      {
        plugin = tmux-session-wizard;
        extraConfig = "set -g @session-wizard 'W'";
      }
    ];
    extraConfig = ''
      # helps with autoread inside vim
      set-option -g focus-events on

      # status bar
      set -g status-style bg=default
      set -g status-left-length 90
      set -g status-right-length 90
      set -g status-justify absolute-centre
      set-window-option -g window-status-current-format "#[fg=black,bg=brightblue] #I:#W "
      set -g pane-active-border-style fg=blue
      set-window-option -g status-left "#[fg=black,bg=brightgreen] #S "
      set-window-option -g status-right ""

      # reload config
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

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

  systemd.user.services.tmux-autostart = {
    Unit = {
      Description = "Autostart Tmux";
      Requires = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "forking";
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -s default -d";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-server";
    };
  };
}
