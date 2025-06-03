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
    ".config/waybar/config".source = ../config/waybar/config;
    ".config/waybar/style.css".source = ../config/waybar/style.css;
    ".config/foot/foot.ini".source = ../config/foot/foot.ini;
    ".config/wofi/config".source = ../config/wofi/config;
    ".config/wlogout/layout".source = ../config/wlogout/layout;
  };

  programs.home-manager.enable = true;
}
