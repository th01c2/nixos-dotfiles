{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-Dark-BL";
      package = pkgs.gruvbox-gtk-theme;
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 22;
    };
  };

  home.packages = with pkgs; [
    gruvbox-gtk-theme
    gruvbox-plus-icons
    bibata-cursors
  ];

  home.sessionVariables = {
    GTK_THEME = "Gruvbox-Dark-BL";
    ICON_THEME = "Gruvbox-Plus-Dark";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "22";
  };
}
