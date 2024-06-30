# Initial setup: https://github.com/ahbnr/nixos-06cb-009a-fingerprint-sensor
{ ... }@args:
{
  imports = [
    # inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
    # inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity
  ];

  # services.open-fprintd.enable = true;
  # services.python-validity.enable = true;

  security.pam.services.sudo.fprintAuth = true;

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = args.nixos-06cb-009a-fingerprint-sensor.lib.libfprint-2-tod1-vfs0090-bingch {
        calib-data-file = ./calib-data.bin;
      };
    };
  };
}
