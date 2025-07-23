{ config, pkgs, inputs, ... }:

{
  # ================================
  # Imports
  # ================================
  imports = [
    ./hardware-configuration.nix      # Hardware config
    ./bash_configuration.nix          # Custom bash settings
    ./hyprland.nix                    # Hyprland-specific config
    ./syncthing.nix
    ../config/themes/stylix.nix
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
  hardware.graphics = {
   enable = true;
   extraPackages = with pkgs; [
     libvdpau-va-gl
     libva
     libva-vdpau-driver
    ];
  };
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "radeonsi";
      VDPAU_DRIVER = "radeonsi";
    };

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
  networking.nameservers = [ "1.1.1.1" "9.9.9.9"];

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
    extraGroups = [ "networkmanager" "wheel" "git" "android-tools" "storage" ];
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
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
};

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

  # Security Poolkit
  security.rtkit.enable = true;

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
  programs.thunar.enable = true;

  # ================================
  # System Services
  # ================================
  services.gvfs.enable = true;                      # Filesystem support
  services.tumbler.enable = true; 		    # Thumbnail support for images
  services.power-profiles-daemon.enable = true;     # Power profiles

  # ================================
  # System Packages
  # ================================
  environment.systemPackages = with pkgs; [
    file-roller  # or xarchiver
    p7zip
    unrar
    unzip
    android-tools           # ADB & Fastboot
    foot                    # Terminal
    ffmpeg                  # Media encoder/decoder
    git                     # Version control
    greetd.tuigreet         # Login TUI
    hyprland                # WM
    imv                     # Image viewer
    libnotify               # Notifications
    hyprpolkitagent
    mpv                     # Video player
    pavucontrol             # Audio manager
    payload-dumper-go       # For Android firmware extraction
    zip                     # Archiver
    libreoffice-qt6-fresh   # Libreoffice
    cmake		    # Generates build files
    gcc			    # Compiles code to executable
    ninja		    # Fast, efficient builder
    gdb			    # Debugs program execution
    texliveFull		    # PDF creator using latex file format
    android-studio	    # Android Apps Development Studio
  ];

  programs.thunar.plugins = with pkgs.xfce; [
	thunar-archive-plugin
	thunar-volman
   ];

  # ================================
  # Nix Settings
  # ================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # ===============================
  # Miscelaneous
  # ==============================
  nixpkgs.config.android_sdk.accept_license = true;

  # ================================
  # State Version
  # ================================
  system.stateVersion = "24.11"; # Adjusted to match your current version
}
