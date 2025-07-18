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
    # Hyprland Config 
    ".config/hypr/hyprland.conf".source = ../config/hypr/hyprland.conf;

    # Hyprlock Config
    ".config/hypr/hyprlock.conf".source = ../config/hypr/hyprlock.conf;

    # Hypridle Config
    ".config/hypr/hypridle.conf".source = ../config/hypr/hypridle.conf;

    # Hyprpaper Config
    ".config/hypr/hyprpaper.conf".source = ../config/hypr/hyprpaper.conf;
    
    # Waybar Config
    ".config/waybar/config".source = ../config/waybar/config;
    ".config/waybar/style.css".source = ../config/waybar/style.css;

    # Foot Terminal Config
    ".config/foot/foot.ini".source = ../config/foot/foot.ini;

    # Wofi Config
    ".config/wofi/config".source = ../config/wofi/config;

    # Shutdown Menu
    ".config/nwg-bar/bar.json".source = ../config/nwg-bar/bar.json;
    ".config/nwg-bar/style.css".source = ../config/nwg-bar/style.css;
  };

  programs.home-manager.enable = true;

}
