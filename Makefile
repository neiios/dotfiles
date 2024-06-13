PWD=$$(pwd)

all:
	echo "What do you even want to do?"

sysm:
	sudo system-manager switch --flake $(PWD)
	rm -f $(PWD)/result

hm:
	home-manager switch --flake $(PWD)

bootstrap-sysm:
	sudo nix run github:numtide/system-manager -- switch --flake $(PWD)
	rm -f $(PWD)/result

bootstrap-hm:
	nix run home-manager/master -- switch --flake $(PWD)

bootstrap-nix:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh