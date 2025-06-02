{ config, pkgs, ... }:

{
  # ================================
  # Imports
  # ================================
  imports = [
    ./hardware-configuration.nix      # Hardware config
    ./bash_configuration.nix          # Custom bash settings
    ./hyprland.nix                    # Hyprland-specific config
  ];

  # ================================
  # Boot Settings
  # ================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ================================
  # Graphics Settings (AMD)
  # ================================
  hardware.graphics.enable = true;

  # Ensure zram module is loaded in early init
  boot.initrd.kernelModules = [ "lz4" ];

  # ================================
  # ZRAM Setup
  # ================================
  zramSwap.enable = true;
  zramSwap.algorithm = "lz4";

  # ================================
  # System Identity & Locale
  # ================================
  networking.hostName = "nixos";          # Define hostname
  time.timeZone = "Europe/Bucharest";     # Time zone
  i18n.defaultLocale = "en_US.UTF-8";     # Default locale

  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT    = "ro_RO.UTF-8";
    LC_MONETARY       = "ro_RO.UTF-8";
    LC_NAME           = "ro_RO.UTF-8";
    LC_NUMERIC        = "ro_RO.UTF-8";
    LC_PAPER          = "ro_RO.UTF-8";
    LC_TELEPHONE      = "ro_RO.UTF-8";
    LC_TIME           = "ro_RO.UTF-8";
  };

  # ================================
  # Networking
  # ================================
  networking.networkmanager.enable = true;

  # ================================
  # Bluetooth
  # ================================
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # ================================
  # Sound
  # ================================
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # ================================
  # Printing
  # ================================
  services.printing.enable = true;

  # ================================
  # Users
  # ================================
  users.users.sebastian = {
    isNormalUser = true;
    description = "Sebastian";
    extraGroups = [ "networkmanager" "wheel" "git" ];
    packages = with pkgs; [
      stremio
      telegram-desktop
      vscodium
    ];
  };

  # ================================
  # Desktop Environment
  # ================================
  services.xserver.enable = false;

  # Enable Hyprland compositor
  programs.hyprland.enable = true;

  # Hyprlock
  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = {};  # PAM auth for hyprlock

  # Login Manager
  services.greetd.enable = true;
  services.greetd.settings = {
    default_session = {
      command = "tuigreet --time --cmd hyprland";
      user = "sebastian";
    };
  };

  # ================================
  # Input & Keymap
  # ================================
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ================================
  # Programs
  # ================================
  programs.firefox.enable = true;

  # ================================
  # System Services
  # ================================
  services.gvfs.enable = true;                      # Filesystem support
  services.power-profiles-daemon.enable = true;     # Power profiles

  # ================================
  # System Packages
  # ================================
  environment.systemPackages = with pkgs; [
    android-tools           # ADB & Fastboot
    foot                    # Terminal
    ffmpeg                  # Media encoder/decoder
    git                     # Version control
    greetd.tuigreet         # Login TUI
    hyprland                # WM
    imv                     # Image viewer
    libnotify               # Notifications
    lxqt.lxqt-policykit     # PolicyKit agent
    mpv                     # Video player
    pavucontrol             # Audio manager
    payload-dumper-go       # For Android firmware extraction
    unzip                   # Unarchiver
    zip                     # Archiver
    jq			    # Json Preview for Yazi
    poppler		    # PDF Renderer for Yazi
    fd 			    # File Searcher for Yazi
    nemo    
  ];

  # ================================
  # Nix Settings
  # ================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # ================================
  # State Version
  # ================================
  system.stateVersion = "24.11"; # Adjusted to match your current version
}
