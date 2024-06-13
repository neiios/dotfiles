{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  # Flatpaks won't be able to use these
  home.packages = with pkgs; [
    inter
    liberation_ttf
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
