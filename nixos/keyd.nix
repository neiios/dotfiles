{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "0001:0001" ];
      settings = {
        main = {
          capslock = "overload(control, esc)";
          enter = "overload(control, enter)";
        };
      };
    };
  };

  # Make palm rejection work with keyd
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
