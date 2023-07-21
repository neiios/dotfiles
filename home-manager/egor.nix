{pkgs, ...}: {
  modules = {
    boilerplate.enable = true;
    emacs.enable = true;
    zsh.enable = true;
    git.enable = true;
    tmux.enable = true;
    foot.enable = true;
  };

  home.packages = with pkgs; [
    nix
    nil
    alejandra
    deploy-rs

    ssh-to-age
    sops
    nixos-rebuild

    shfmt
    shellcheck
    nodePackages.bash-language-server
  ];

  programs.thunderbird = {
    enable = true;
    profiles.nix = {
      isDefault = true;
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
