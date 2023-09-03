{
  config,
  lib,
  pkgs,
  ...
} @ args: {
  # TODO: Upstream fixes
  xdg.systemDirs.data = [
    # Nix profiles
    "\${NIX_STATE_DIR:-/nix/var/nix}/profiles/default/share"
    "${config.home.profileDirectory}/share"

    # Distribution-specific
    "/usr/share/ubuntu"
    "/usr/local/share"
    "/usr/share"
    "/var/lib/snapd/desktop"
  ];

  # We need to append system-wide FHS directories due to the default prefix
  # resolving to the Nix store.
  # https://github.com/nix-community/home-manager/pull/2891#issuecomment-1101064521
  home.sessionVariables = {
    XCURSOR_PATH =
      "$XCURSOR_PATH\${XCURSOR_PATH:+:}"
      + lib.concatStringsSep ":" [
        "${config.home.profileDirectory}/share/icons"
        "/usr/share/icons"
        "/usr/share/pixmaps"
      ];
  };

  home.sessionVariablesExtra = let
    nixPkg =
      if config.nix.package == null
      then pkgs.nix
      else config.nix.package;
  in ''
    . "${nixPkg}/etc/profile.d/nix.sh"

    # reset TERM with new TERMINFO available (if any)
    export TERM="$TERM"
  '';

  systemd.user.sessionVariables = let
    distroTerminfoDirs = lib.concatStringsSep ":" [
      "/etc/terminfo" # debian, fedora, gentoo
      "/lib/terminfo" # debian
      "/usr/share/terminfo" # package default, all distros
    ];
  in {
    NIX_PATH = "$HOME/.local/state/nix/defexpr\${NIX_PATH:+:}$NIX_PATH";
    TERMINFO_DIRS = "${config.home.profileDirectory}/share/terminfo:$TERMINFO_DIRS\${TERMINFO_DIRS:+:}${distroTerminfoDirs}";
  };
}
