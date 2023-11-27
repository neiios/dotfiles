# Ze Nix Dotfiles III

```bash
# init on a new machine with nix installed

# clone repo
git clone git@github.com:richard96292/dotfiles ~/Dev/dotfiles

# test build
nix run ~/Dev/dotfiles -- build --flake ~/Dev/dotfiles

# activate new config
nix run ~/Dev/dotfiles -- switch --flake ~/Dev/dotfiles
```
