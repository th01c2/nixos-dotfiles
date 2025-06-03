{ config, pkgs, ... }:

{
  imports = [
    ../nixos/modules/theme.nix
  ];

  home.username = "sebastian";
  home.homeDirectory = "/home/sebastian";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
  nerd-fonts.fira-code
  nerd-fonts.jetbrains-mono
  nerd-fonts.hack
  font-awesome
];


  # Hyprland configuration symlink
  home.file = {
    ".config/hypr/hyprland.conf".source = ../config/hypr/hyprland.conf;
    ".config/hypr/hyprlock.conf".source = ../config/hypr/hyprlock.conf;
    ".config/hypr/hypridle.conf".source = ../config/hypr/hypridle.conf;
    ".config/hypr/hyprpaper.conf".source = ../config/hypr/hyprpaper.conf;
    
    # Waybar Config
    ".config/waybar/config".source = ../config/waybar/config;
    ".config/waybar/style.css".source = ../config/waybar/style.css;

    # Foot Terminal Config
    ".config/foot/foot.ini".source = ../config/foot/foot.ini;

    # Wofi Config
    ".config/wofi/config".source = ../config/wofi/config;

    # Wlogout
    ".config/wlogout/layout".source = ../config/wlogout/layout;
    ".config/wlogout/style.css".source = ../config/wlogout/style.css;
    ".config/wlogout/assets/power-off-solid.svg".source = "../icons/Wlogout/power-off-solid.svg";
  };

  programs.home-manager.enable = true;
}
