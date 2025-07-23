{ config, pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
    image = ../../wallpapers/wallpaper-girl-anime.png;
    
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 48; # Optional
    };

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
	gtk.enable = true;
	};
  };
}
