
install:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	nix run home-manager/master -- switch --flake github:richard96292/dotfiles
	grep -qxF "/home/${USERNAME}/.local/state/nix/profile/bin/zsh" || echo "/home/${USERNAME}/.local/state/nix/profile/bin/zsh" | sudo tee -a /etc/shells
	chsh -s "/home/${USERNAME}/.local/state/nix/profile/bin/zsh"
