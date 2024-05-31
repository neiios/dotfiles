# DISCLAIMER: This is just fucking digusting. Don't look at this file. Forget it exists.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Makes programs and scripts with hardcoded paths (/bin/bash) automagically work
  services.envfs.enable = true;

  # Makes programs compiled for sane Linux distros work on NixOS
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;

    # List is taken from: https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/appimage/default.nix
    # and: https://github.com/Mic92/dotfiles/blob/main/nixos/modules/nix-ld.nix
    libraries =
      let
        removeNull = l: pkgs.lib.lists.remove null l;
      in
      with pkgs;
      # And a lot more stuff
      qemu_full.buildInputs
      ++ ffmpeg-full.buildInputs
      ++ imagemagickBig.buildInputs
      ++ gst_all_1.gstreamer.buildInputs
      # ++ appimage-run.buildInputs # TODO: Empty list
      # ++ steam-run.buildInputs # TODO: Empty list
      # For some reason there is a null in a buildInputs list ¯\_(ツ)_/¯
      ++ (removeNull gst_all_1.gst-plugins-base.buildInputs)
      ++ (removeNull gst_all_1.gst-plugins-good.buildInputs)
      ++ (removeNull gst_all_1.gst-plugins-bad.buildInputs)
      ++ (removeNull gst_all_1.gst-plugins-ugly.buildInputs)
      ++ [
        # default
        zlib
        zstd
        stdenv.cc.cc
        curl
        openssl
        attr
        libssh
        bzip2
        libxml2
        acl
        libsodium
        util-linux
        xz
        systemd

        fuse # for appimages
        gtk3
        bashInteractive
        gnome.zenity
        which
        perl
        xdg-utils
        iana-etc
        krb5
        gsettings-desktop-schemas
        hicolor-icon-theme # dont show a gtk warning about hicolor not being installed

        libbsd # Android qemu based emulator

        desktop-file-utils

        libGL
        libdrm

        glib
        gtk2
        gdk-pixbuf

        freetype
        curlWithGnuTls
        nspr
        nss
        fontconfig
        cairo
        pango
        expat
        dbus
        cups
        libcap
        SDL2
        libusb1
        udev
        dbus-glib
        atk
        at-spi2-atk
        libudev0-shim

        libGLU
        libuuid
        libogg
        libvorbis
        SDL
        SDL2_image
        glew110
        libidn
        tbb
        wayland
        mesa
        libxkbcommon
        vulkan-loader

        flac
        freeglut
        libjpeg
        libpng12
        libpulseaudio
        libsamplerate
        libmikmod
        libthai
        libtheora
        libtiff
        pixman
        speex
        SDL_image
        SDL_ttf
        SDL_mixer
        SDL2_ttf
        SDL2_mixer
        libappindicator-gtk2
        libcaca
        libcanberra
        libgcrypt
        libvpx
        librsvg
        xorg.libXft
        libvdpau
        alsa-lib

        harfbuzz
        e2fsprogs
        libgpg-error
        keyutils.lib
        libjack2
        fribidi
        p11-kit

        gmp

        # libraries not on the upstream include list, but nevertheless expected
        # by at least one appimage
        libtool.lib # for Synfigstudio
        at-spi2-core
        pciutils # for FreeCAD
        pipewire # immersed-vr wayland support

        fuse3
        icu
        libappindicator-gtk3
        libglvnd
        libnotify
        libunwind
        pipewire

        xorg.xrandr
        xorg.libXcomposite
        xorg.libXtst
        xorg.libXrandr
        xorg.libXext
        xorg.libX11
        xorg.libXfixes
        xorg.libXinerama
        xorg.libXdamage
        xorg.libXcursor
        xorg.libXrender
        xorg.libXScrnSaver
        xorg.libXxf86vm
        xorg.libXi
        xorg.libSM
        xorg.libICE
        xorg.xkeyboardconfig
        xorg.libpciaccess
        xorg.libxshmfence # for apple-music-electron
        xorg.libxkbfile
        xorg.libxshmfence
        xorg.libXt
        xorg.libXmu
        xorg.libxcb
        xorg.xcbutil
        xorg.xcbutilwm
        xorg.xcbutilimage
        xorg.xcbutilkeysyms
        xorg.xcbutilrenderutil
        xorg.libpthreadstubs
        xorg.libXaw
        xorg.libXdmcp
        xorg.libXv

        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav

        alsa-plugins
        bash
        cabextract
        coreutils
        freealut
        giflib
        gnutls
        lcms2
        libevdev
        libgudev
        libkrb5
        libmpeg2
        libopus
        libpng
        libselinux
        libsndfile
        libsoup
        libv4l
        libva
        libwebp
        mpg123
        ncurses
        ocl-icd
        openal
        openldap
        samba4
        sane-backends
        sqlite
        unixODBC
        v4l-utils

        # Not formally in runtime but needed by some games
        at-spi2-core # CrossCode
        json-glib # paradox launcher (Stellaris)
        libxkbcommon # paradox launcher
        libvorbis # Dead Cells
        libxcrypt # Alien Isolation, XCOM 2, Company of Heroes 2
        mono
        xorg.libXScrnSaver # Dead Cells
        icu # dotnet runtime, e.g. Stardew Valley
        libbsd
        libidn2
        libpsl
        nghttp2.lib
        rtmpdump
        libelf
        gnome2.GConf
        ffmpeg
        libdbusmenu-gtk2
        libindicator-gtk2
        gnome2.pango
        alsaLib
      ];
  };
}
