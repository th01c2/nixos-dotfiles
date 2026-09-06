{ config, pkgs, ... }:

{
  # Enable the Hyprland window manager
  programs.sway.enable = true;

  environment.systemPackages = with pkgs; [
    waybar           # Status bar
    wlsunset	     # Blue Light Filter
    hyprshot
    grimblast
    slurp            # Select region for screenshots
    wl-screenrec     # Screen Recorder Utility
    wl-clipboard     # Clipboard utilities for Wayland
    qt5.qtwayland    # Qt Wayland support
    qt6.qtwayland    # Qr Wayland 6 support
    foot	     # Foot terminal
    brightnessctl    # Change Brightness
    blueman	     # Bluetooth Daemon
    networkmanagerapplet #Network Button (Neede for Waybar)
    nwg-look	     # Change theme
    nwg-bar          # Poweroff/Reboot/Suspend button menu
    fuzzel	     # ROFI/WOFI Alternative
    swaynotificationcenter # The name tells everything already
    autotiling
  ];

xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk  # fallback
    ];
    config.sway = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.Screencast" = "wlr";
      "org.freedesktop.impl.portal.Screenshot" = "wlr";
    };
  };  # If using a display manager like greetd or SDDM, configure it here
  # services.greetd.enable = true;
  # services.greetd.settings.default_session.command = "Hyprland";

  # Optional: Set default session if using no display manager
  # users.users.yourUsername.initialSession = "Hyprland";
}
