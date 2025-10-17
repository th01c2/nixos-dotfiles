{ config, pkgs, inputs, ... }:

{
  # ================================
  # Imports
  # ================================
  imports = [
    ./hardware-configuration.nix      # Hardware config
    ./bash_configuration.nix          # Custom bash settings
    ./build-tools.nix		      # Build Tools for Compiling
    ./hyprland.nix                    # Hyprland-specific config
    ../config/themes/stylix.nix
  ];

  # ================================
  # Boot Settings
  # ================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];

  # Kernel parameters for AMD Vega 8 stability
  boot.kernelParams = [
    "amdgpu.abmlevel=0"       # Disable backlight flickering on Vega
    "amdgpu.dcdebugmask=0x10" # Fix Wayland freezes on Vega
  ];

  # ================================
  # Graphics Settings (AMD)
  # ================================
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libvdpau-va-gl     # VA-API to VDPAU wrapper for video decode
      libva              # Video Acceleration API support
      libva-vdpau-driver # VDPAU backend for VA-API
      rocmPackages.clr.icd # AMD HIP compute support
    ];
  };

  # Ensure zram module is loaded in early init
  boot.initrd.kernelModules = [ "lz4" "amdgpu" ];

  # ================================
  # ZRAM Setup
  # ================================
  zramSwap.enable = true;
  zramSwap.algorithm = "lz4";
  zramSwap.priority = 100;
  zramSwap.memoryPercent = 50; # Use 50% of RAM (8GB with 16GB total)
  
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024; # 16GB
    priority = 10;
  }];

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
    extraGroups = [ "networkmanager" "wheel" "git" "android-tools" "storage" "input" ];
    packages = with pkgs; [
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
  };

  # Hyprlock
  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = {};  # PAM auth for hyprlock

  # Login Manager
  services.greetd.enable = true;
  services.greetd.settings = {
    default_session = {
      command = "tuigreet --time --remember --cmd hyprland";
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
  services.flatpak.enable = true;

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
    file-roller  	    # Archive manager
    file
    fastfetch		    # System info display
    p7zip		    # 7z compression
    unrar		    # RAR extraction
    unzip		    # ZIP extraction
    android-tools           # ADB & Fastboot
    foot                    # GPU terminal
    ffmpeg                  # Media encoder/decoder
    git                     # Version control
    curl		    # Download files
    wget		    # Download files alt
    tuigreet     	    # Login TUI
    hyprland                # WM
    imv                     # Image viewer
    libnotify               # Notifications
    hyprpolkitagent	    # Sudo apps agent
    mpv                     # Video player
    pavucontrol             # Audio manager
    payload-dumper-go       # Android firmware extract
    zip                     # Archiver
    texliveFull		    # LaTeX for PDF
    android-studio	    # Android dev IDE
    deluge		    # Torrent client
    thunderbird		    # Email client
    wasistlos		    # WhatsApp client
    apktool		    # APK decompiler
    blender		    # 3D design
    wireshark               # Network analyzer
    distrobox               # Container wrapper
    zulu24                  # Java runtime
    woeusb-ng               # Windows USB creator
    ntfs3g                  # NTFS support
    apksigner               # APK signer
    qemu-utils              # QEMU utilities
    simg2img                # Android image converter
    python3                 # Python runtime
    python313Packages.tkinter # Python GUI toolkit
  ];

  programs.thunar.plugins = with pkgs.xfce; [
	thunar-archive-plugin   # Archive integration for Thunar
	thunar-volman           # Volume management for Thunar
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

  # ==============================
  # Ignore Power Button
  # ==============================
  services.logind.settings = {
    Login = {
      HandlePowerKey = "ignore";
    };
  };

  # ===============================
  # Distrobox
  # ===============================
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # ================================
  # State Version
  # ================================
  system.stateVersion = "24.11"; # Adjusted to match your current version
}
