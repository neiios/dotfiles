{ pkgs, ... }: {
      environment.systemPackages = with pkgs; [ neovim ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      
      programs.fish.enable = true;
      programs.fish.interactiveShellInit = ''
        # Remove greeting; use 'help' if needed
        set fish_greeting

        # Add IDEs from toolbox to the PATH
        fish_add_path --append --move ~/Library/Application Support/JetBrains/Toolbox/scripts

        # Wixstaller
        fish_add_path --prepend --move ~/.local/bin

        # Rancher Desktop
        fish_add_path --prepend --move ~/.rd/bin
      '';

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
}