{
  pkgs,
  username,
  ...
}: {
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  programs.home-manager.enable = true;
  home.stateVersion = "23.05";
  targets.genericLinux.enable = true;
  systemd.user.startServices = "sd-switch";

  modules = {
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

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  nix = {
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
      use-xdg-base-directories = true;
    };
  };
}
