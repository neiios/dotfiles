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
