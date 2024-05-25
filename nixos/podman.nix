{
  config,
  lib,
  pkgs,
  home-manager,
  ...
}:
{
  virtualisation.containers.enable = true;
  virtualisation.oci-containers.backend = "podman";
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Make docker tools use podman socket
  home-manager.users.igor.home.sessionVariables = {
    DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
  };

  # Hide "Emulate Docker CLI using podman." message
  systemd.tmpfiles.rules = [ "f /etc/containers/nodocker 755 root root - -" ];

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    # start group of containers for dev 
    # for now docker-compose will be used instead of podman-compose by default
    docker-compose
    podman-compose
  ];
}
