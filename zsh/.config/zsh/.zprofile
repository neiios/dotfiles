# Launch wm if on first tty
if [[ -z $DISPLAY && "$(tty)" = "/dev/tty1" ]]; then
  # XDG vars
  export XDG_CURRENT_DESKTOP=sway XDG_SESSION_TYPE=wayland XDG_SESSION_DESKTOP=sway
  # QT vars
  export QT_AUTO_SCREEN_SCALE_FACTOR=1 QT_QPA_PLATFORM="wayland;xcb" QT_WAYLAND_DISABLE_WINDOWDECORATION=1 QT_QPA_PLATFORMTHEME=qt5ct
  # JAVA vars
  export _JAVA_AWT_WM_NONEREPARENTING=1
  # Cursor vars
  export XCURSOR_THEME=Adwaita XCURSOR_SIZE=24
  # Mozilla
  export MOZ_ENABLE_WAYLAND=1
  exec sway
fi
