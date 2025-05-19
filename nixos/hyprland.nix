{ config, pkgs, ... }:

{
  # Enable the Hyprland window manager
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    hyprland
    waybar           # Status bar
    wofi             # Launcher (like rofi)
    grim             # Screenshot tool
    slurp            # Select region for screenshots
    wl-clipboard     # Clipboard utilities for Wayland
    qt5.qtwayland    # Qt Wayland support
    qt6.qtwayland
    foot
    hyprsunset
    hyprpaper
    brightnessctl
    blueman
    networkmanagerapplet
    gruvbox-gtk-theme
    gruvbox-dark-icons-gtk
  ];

  # If using a display manager like greetd or SDDM, configure it here
  # services.greetd.enable = true;
  # services.greetd.settings.default_session.command = "Hyprland";

  # Optional: Set default session if using no display manager
  # users.users.yourUsername.initialSession = "Hyprland";
}
