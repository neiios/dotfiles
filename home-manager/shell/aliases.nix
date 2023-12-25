{...}: {
  programs.zsh.shellAliases = {
    hms = "home-manager switch";
    nfc = "nix flake check";
    sudo = "sudo ";
    ls = "ls --color=auto";
    lsa = "ls -lah";
    dps = "docker ps -a --format=\"table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.RunningFor}}\"";
    dcu = "docker compose -d";
    dcd = "docker compose down";
    dclean = "docker system prune -a --volumes";
  };

  programs.zsh.initExtra = ''
    # Allows to create a shell with specified packages (even unfree). Usage: nsh gimp git discord
    function nsh() { ARGS=("$@"); NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "''${ARGS[@]/#/nixpkgs#}" }

    function telegram-sticker() {
      ffmpeg -i $1 -c:v libvpx-vp9 -vf scale=512:-1 -pix_fmt yuva420p -metadata:s:v:0 alpha_mode="1" -t 00:00:03 ~/Videos/$2.webm
    }

    function mkcd() {
      mkdir $1 && cd $1
    }

    function unnest() {
      mv ./$1/{.,}* . && rmdir $1
    }
  '';
}
