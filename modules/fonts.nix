{pkgs, ...}:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-extra
    noto-fonts-cjk-serif 
    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts-lgc-plus
  ];
}
