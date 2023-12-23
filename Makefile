USERNAME := $(shell whoami)
NIX_INSTALL_SCRIPT := https://install.determinate.systems/nix
NIX_HOME_MANAGER_FLAKE := github:richard96292/dotfiles
NIX_ZSH_PATH := /home/$(USERNAME)/.local/state/nix/profile/bin/zsh

install: nix_install home_manager_switch set_default_shell

nix_install:
	curl --proto '=https' --tlsv1.2 -sSf -L $(NIX_INSTALL_SCRIPT) | sh -s -- install

home_manager_switch:
	nix run home-manager/master -- switch --flake $(NIX_HOME_MANAGER_FLAKE)

set_default_shell:
	grep -qxF "$(NIX_ZSH_PATH)" /etc/shells || echo "$(NIX_ZSH_PATH)" | sudo tee -a /etc/shells
	chsh -s "$(NIX_ZSH_PATH)"

clean:
	rm -rf ./build

.PHONY: install nix_install home_manager_switch set_default_shell clean
