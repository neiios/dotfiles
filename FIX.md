# A collection of fixes for small issues

## Update nix

```bash
sudo -i nix upgrade-nix
```

## Fix vscode file manager

```bash
xdg-mime query default inode/directory
xdg-mime default org.gnome.Nautilus.desktop inode/directory
```

## Bind mute key

```bash
ratbagctl cheering-viscacha button 5 action set macro key_numlock
```
