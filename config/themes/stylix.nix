{ config, pkgs, ... }:

{
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    fonts = {
      serif = { package = pkgs.dejavu_fonts; name = "DejaVu Serif"; };
      sansSerif = { package = pkgs.dejavu_fonts; name = "DejaVu Sans"; };
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font";
      };
      emoji = { package = pkgs.noto-fonts-emoji; name = "Noto Color Emoji"; };
    };

    targets = {
      hyprland.enable = true;
      gtk.enable = true;
      qt.enable = true;
      waybar.enable = true;
      rofi.enable = true;
      kitty.enable = true;
      hyprland.hyprpaper.enable = config.stylix.image != null;
    };
  };
}
