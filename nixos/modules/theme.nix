{ config, pkgs, userConfig, ... }:

{

  # GTK
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  # QT
  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.name = "kvantum";
  };

  # Set qtquickcontrols2 to use plasma theme (like kde-connect)
  xdg.configFile."qtquickcontrols2.conf".text = ''
    [Controls]
    Style=org.kde.desktop
  '';

  home.packages = with pkgs; [
    # Theming
    nwg-look                           # gtk configuration tool
    libsForQt5.qt5ct                   # qt5 configuration tool
    kdePackages.qt6ct                  # qt6 configuration tool
    libsForQt5.qtstyleplugin-kvantum   # svg based qt5 theme engine
    kdePackages.qtstyleplugin-kvantum  # svg based qt6 theme engine
    libsForQt5.qt5.qtwayland           # wayland support in qt5
    kdePackages.qtwayland              # wayland support in qt6
    adw-gtk3                           # adwaita gtk3 theme
    catppuccin-gtk                     # catppuccin-gtk
    magnetic-catppuccin-gtk            # catppuccin-gtk new
    gruvbox-gtk-theme                  # gruvbox-gtk
    catppuccin-kvantum                 # catppuccin kvantum theme
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    GTK_THEME = "Catppuccin-GTK-Dark";
    ICON_THEME = "Papirus-Dark";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = 22;
  };

}
