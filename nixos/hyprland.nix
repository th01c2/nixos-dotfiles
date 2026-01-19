{ config, pkgs, ... }:

{
  # Enable the Hyprland window manager
  programs.hyprland.enable = true;

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
    hyprsunset	     # Night Light Mode
    hyprpaper	     # Wallpaper Utility
    hypridle	     # Add Inactivity Timer for Hyprlock
    brightnessctl    # Change Brightness
    blueman	     # Bluetooth Daemon
    networkmanagerapplet #Network Button (Neede for Waybar)
    nwg-look	     # Change theme
    hyprcursor       # Cursor themes
    nwg-bar          # Poweroff/Reboot/Suspend button menu
    mako	     # Notification daemon for Wayland
    fuzzel	     # ROFI/WOFI Alternative
    hyprpicker
  ];

  # If using a display manager like greetd or SDDM, configure it here
  # services.greetd.enable = true;
  # services.greetd.settings.default_session.command = "Hyprland";

  # Optional: Set default session if using no display manager
  # users.users.yourUsername.initialSession = "Hyprland";
}
