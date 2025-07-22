{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
  };

  home.packages = with pkgs; [
    gruvbox-plus-icons
  ];

  home.sessionVariables = {
    ICON_THEME = "Gruvbox-Plus-Dark";
  };
}
