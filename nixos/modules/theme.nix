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

  # For Qt5/6 applications
  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    style=org.kde.desktop
    icon_theme=Gruvbox-Plus-Dark
  '';

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    style=org.kde.desktop
    icon_theme=Gruvbox-Plus-Dark
  '';

  xdg.configFile."qtquickcontrols2.conf".text = ''
    [Controls]
    Style=org.kde.desktop
  '';

  home.packages = with pkgs; [
    libsForQt5.qt5ct
    kdePackages.qt6ct
    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
    gruvbox-gtk-theme
    gruvbox-plus-icons
    bibata-cursors
  ];

  home.sessionVariables = {
    GTK_THEME = "Gruvbox-Dark-BL";
    ICON_THEME = "Gruvbox-Plus-Dark";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "22";
    QT_QPA_PLATFORMTHEME = "qt5ct";  # For Qt5 apps
    QT_STYLE_OVERRIDE = "org.kde.desktop"; # Optional but ensures KDE style
  };
}
