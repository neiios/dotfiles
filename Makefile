PWD=$$(pwd)

sysm:
	sudo -i system-manager switch --flake $(PWD)
	rm -f $(PWD)/result

hm:
	home-manager switch --flake $(PWD)

bootstrap-sysm:
	sudo -i nix run github:numtide/system-manager -- switch --flake $(PWD)
	rm -f $(PWD)/result

bootstrap-hm:
	nix run home-manager/master -- switch --flake $(PWD)
