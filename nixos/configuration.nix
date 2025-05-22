{ config, pkgs, ... }:

{
  imports = [
       # Nix Modules
      ./hardware-configuration.nix
      ./bash_configuration.nix
      ./hyprland.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ====================================
  # ZRAM Setup
  # ====================================
  zramSwap.enable = true;          # Turn ZRAM on
  zramSwap.algorithm = "zstd";     # Use zstd for good balance
  boot.initrd.kernelModules = [ "zram" ]; # Ensure zram module is loaded early

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  # Bluetooth
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # Enable Hyprland environment.
  services.xserver.enable = false;
  services.xserver.displayManager.gdm.enable = true;

  # Enable Hyprlock
  programs.hyprlock.enable = true;

  # Configure PAM for Hyprlock to allow authentication
  security.pam.services.hyprlock = {};

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.sebastian = {
    isNormalUser = true;
    description = "Sebastian";
    extraGroups = [ "networkmanager" "wheel" "git" ];
    packages = with pkgs; [
	telegram-desktop
	stremio
	vscodium
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.thunar.enable = true;
  programs.file-roller.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	pavucontrol # Audio Manager
	lxqt.lxqt-policykit
	hyprland # Hyprland
	foot # Terminal
	git # Git...
        mpv # Video Streamer
	imv  # Image Viewer
        ffmpeg # Codec
	zip # Archive files
	unzip # Archive Extractor
	libnotify
  ];

  programs.thunar.plugins = with pkgs.xfce; [
	thunar-archive-plugin
	thunar-volman
   ];

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  services.power-profiles-daemon.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
