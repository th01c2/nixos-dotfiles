{
  config,
  inputs,
  pkgs,
  ...
}:
{
  # scheme = ./home-config/colors/doomvibrant.yaml;
  stylix = {
    enable = true;
    base16Scheme = {
      base00 = "282828";
      base01 = "282828";
      base02 = "282828";
      base03 = "282828";
      base04 = "bdae93";
      base05 = "d5c4a1";
      base06 = "ebdbb2";
      base07 = "fbf1c7";
      base08 = "fb4934";
      base09 = "fe8019";
      base0A = "fabd2f";
      base0B = "b8bb26";
      base0C = "8ec07c";
      base0D = "83a598";
      base0E = "d3869b";
      base0F = "d65d0e";
    };
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    # base16Scheme = ./home-config/colors/doomone.yaml;
    cursor = {
      package = pkgs.libsForQt5.breeze-qt5;
      name = "breeze_cursors";
      size = 24;
    };
    # image = ../wallpapers/warm/railtrack.jpg;
    image = ../../wallpapers/minimal_c.png;
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        # package = pkgs.noto-fonts;
        package = pkgs.nerd-fonts.fantasque-sans-mono;
        name = "FantasqueSansM Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        terminal = 14;
        applications = 10;
        desktop = 10;
      };
    };
    targets = {
      gtk.enable = true;
    };

    polarity = "dark";
  };
}
