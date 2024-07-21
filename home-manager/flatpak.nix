args: {
  imports = [ args.nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      "org.mozilla.firefox"
      "io.gitlab.librewolf-community"
      "io.github.ungoogled_software.ungoogled_chromium"

      "org.mozilla.Thunderbird"
      "org.telegram.desktop"
      "org.gnome.Fractal"
      "dev.vencord.Vesktop"

      "com.spotify.Client"
      "md.obsidian.Obsidian"
      "org.libreoffice.LibreOffice"
      "com.getpostman.Postman"

      "com.github.tchx84.Flatseal"
      # "com.mattjakeman.ExtensionManager" # installed with nix
      # "re.sonny.Junction" # installed with nix
    ];

    overrides = {
      global = {
        Environment = {
          # Fix un-themed cursor in some Wayland apps
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
        };
      };

      "md.obsidian.Obsidian".Context = {
        share = [ "!ipc" ];
        sockets = [
          "wayland"
          "!x11"
          "!ssh-auth"
          "!pulseaudio"
        ];
        filesystems = [
          "!home"
          "!/run/media"
          "!/mnt"
          "!/media"
          "!xdg-run/app/com.discordapp.Discord"
          "!xdg-run/gnupg"
        ];
      };
    };
  };
}
