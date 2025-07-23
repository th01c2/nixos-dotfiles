{ config, pkgs, userConfig, ... }:

{

  # GTK
  gtk = {
    enable = true;
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
  };

  # Set qtquickcontrols2 to use plasma theme (like kde-connect)
  xdg.configFile."qtquickcontrols2.conf".text = ''
    [Controls]
    Style=org.kde.desktop
  '';

  home.packages = with pkgs; [
    # Theming
    gruvbox-gtk-theme                  # gruvbox-gtk
  ];

  home.sessionVariables = {
    ICON_THEME = "Gruvbox-Plus-Dark ";
  };

}
