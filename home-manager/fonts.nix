{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  # Flatpaks won't be able to use these
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji

    inter
    ubuntu_font_family
    liberation_ttf
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
