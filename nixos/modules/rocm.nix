{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };
  hardware.opengl.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  systemd.tmpfiles.rules = [ "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}" ];
  environment.systemPackages = with pkgs; [
    rocmPackages.clr
    clinfo
  ];
}
