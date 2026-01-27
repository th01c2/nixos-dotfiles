{ config, pkgs, inputs, lib, ... }:

{
  # ================================
  # IMPORTS
  # ================================
  imports = [
    ./hardware-configuration.nix
    ./bash_configuration.nix
    ./build-tools.nix
    ./hyprland.nix
    ../config/themes/stylix.nix
  ];

  # ================================
  # BOOT CONFIGURATION
  # ================================
  boot = {
    # Bootloader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    bootspec.enable = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  # ================================
  # HARDWARE
  # ================================
  
  # Graphics (AMD)
  hardware.graphics = {
    enable = true;
    enable32Bit = false;
    extraPackages = with pkgs; [
      libvdpau-va-gl
      libva
      libva-vdpau-driver
    ];
  };

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Memory Management (ZRAM + Swap)
  zramSwap = {
    enable = true;
    algorithm = "lz4";
    priority = 100;
    memoryPercent = 50;  # 8GB with 16GB total RAM
  };

  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;  # 16GB
    priority = 10;
  }];

  # ================================
  # SYSTEM IDENTITY & LOCALIZATION
  # ================================
  networking.hostName = "nixos";
  time.timeZone = "Europe/Bucharest";
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  # ================================
  # NETWORKING
  # ================================
  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 57307 ];
      allowedUDPPorts = [ 19132 2222 ];
    };
    # nameservers = [ "1.1.1.1" "1.0.0.1" ];  # Uncomment if needed
  };

  # ================================
  # AUDIO
  # ================================
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Add this line - it handles the "default device" logic
    wireplumber.enable = true;
  };

  # ================================
  # DESKTOP ENVIRONMENT
  # ================================
  services.xserver = {
    enable = false;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Hyprland
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = {};

  # Login Manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "tuigreet --time --remember --cmd start-hyprland";
      user = "sebastian";
    };
  };

  # ================================
  # USERS
  # ================================
  users.users.sebastian = {
    isNormalUser = true;
    description = "Sebastian";
    extraGroups = [
      "networkmanager"
      "wheel"
      "git"
      "android-tools"
      "storage"
      "input"
      "libvirtd"
      "docker"
    ];
    packages = with pkgs; [
	
    ];
  };

  # ================================
  # VIRTUALIZATION
  # ================================
  virtualisation = {
    podman.enable = false;
    docker.enable = true;
    oci-containers.backend = "docker";
    
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };

  # ================================
  # SYSTEM PROGRAMS & SERVICES
  # ================================
  programs = {
    firefox.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    fish.enable = true;
  };

  services = {
    blueman.enable = true;
    flatpak.enable = true;
    tailscale.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    power-profiles-daemon.enable = true;
    
    logind.settings.Login.HandlePowerKey = "ignore";
  };

  security.rtkit.enable = true;

  # ================================
  # SYSTEM PACKAGES
  # ================================
  environment.systemPackages = with pkgs; [
    file-roller
    file
    p7zip
    unrar
    unzip
    zip
    vim
    foot
    fastfetch
    tuigreet
    libnotify
    hyprpolkitagent
    ffmpeg
    imv
    mpv
    pavucontrol
    audacity
    telegram-desktop
    vscodium
    git
    git-repo
    android-tools
    android-studio
    apktool
    apksigner
    python3
    curl
    wget
    chromium
    thunderbird
    wasistlos
    deluge
    remmina
    freerdp
    payload-dumper-go
    simg2img
    distrobox
    qemu-utils
    virt-viewer
    usbutils
    blender
    bottles
    unityhub
    texliveFull
    woeusb-ng
    ntfs3g
    mission-center
  ];

  # ================================
  # NIX CONFIGURATION
  # ================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  # ================================
  # STATE VERSION
  # ================================
  system.stateVersion = "24.11";  # DO NOT CHANGE
}
