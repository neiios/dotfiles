sysm:
	sudo -i system-manager switch --flake $$(pwd)

hm:
	home-manager switch --flake $$(pwd)

bootstrap-sysm:
	sudo -i nix run github:numtide/system-manager -- switch --flake $$(pwd)

bootstrap-hm:
	nix run home-manager/master -- switch --flake $$(pwd)
