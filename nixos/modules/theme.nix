{ config, pkgs, userConfig, ... }:

{

  # GTK
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  # Set qtquickcontrols2 to use plasma theme (like kde-connect)
  xdg.configFile."qtquickcontrols2.conf".text = ''
    [Controls]
    Style=org.kde.desktop
  '';

  home.packages = with pkgs; [
    # Theming
    libsForQt5.qt5ct                   # qt5 configuration tool
    kdePackages.qt6ct                  # qt6 configuration tool
    libsForQt5.qtstyleplugin-kvantum   # svg based qt5 theme engine
    kdePackages.qtstyleplugin-kvantum  # svg based qt6 theme engine
    libsForQt5.qt5.qtwayland           # wayland support in qt5
    kdePackages.qtwayland              # wayland support in qt6
    gruvbox-gtk-theme                  # gruvbox-gtk
  ];

  home.sessionVariables = {
    GTK_THEME = "Adwaita-Dark";
    ICON_THEME = "Gruvbox-Plus-Dark ";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = 22;
  };

}
