{ config, pkgs, inputs, lib, ... }:
{
  # ================================
  # IMPORTS
  # ================================
  imports = [
    ./hardware-configuration.nix
    ./bash_configuration.nix
    ./hyprland.nix
    ../config/themes/stylix.nix
    ./zen3.nix
  ];

  # ================================
  # BOOT CONFIGURATION
  # ================================
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "v4l2loopback" "amneziawg" ];
    extraModulePackages = [ 
      config.boot.kernelPackages.v4l2loopback 
      config.boot.kernelPackages.amneziawg
    ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
  };

  # ================================
  # HARDWARE
  # ================================
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libvdpau-va-gl
      libva
      libva-vdpau-driver
    ];
  };
  
  hardware.bluetooth.enable = true;
  
  zramSwap = {
    enable = true;
    algorithm = "lz4";
    priority = 100;
    memoryPercent = 100;
  };
  
  swapDevices = [{
    device = "/swapfile";
    size = 8 * 1024;
    priority = 10;
  }];

  hardware.printers.ensureDefaultPrinter = "EPSON_L3230_Series";

  # ================================
  # SYSTEM IDENTITY & LOCALIZATION
  # ================================
  networking.hostName = "nixos-sebastian";
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
  # NETWORKING & FIREWALL
  # ================================
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = true;
      # Force 1.1.1.1 / 1.0.0.1 ahead of any DHCP-provided DNS,
      # per-connection, for every NetworkManager profile.
      insertNameservers = [ "1.1.1.1" "1.0.0.1" ];
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];                 
      allowedUDPPorts = [ ];              
      trustedInterfaces = [ "tun0" "wg0" ];                 
      checkReversePath = "loose";                         
    };
    nftables.enable = true;
  };

  # ================================
  # POWER MANAGEMENT & LAPTOP
  # ================================
  powerManagement.enable = true;

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "schedutil";
        turbo = "auto";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  services.thermald.enable = true;
  services.upower.enable = true;
  services.fstrim.enable = true;

  # ================================
  # SERVICES
  # ================================
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    xserver = {
      enable = false;
      xkb = { layout = "us"; variant = ""; };
    };

    greetd = {
      enable = true;
      settings.default_session = {
        command = "tuigreet --time --remember --cmd sway";
        user = "sebastian";
      };
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };

    blueman.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    power-profiles-daemon.enable = false;

    logind = {
      settings = {
        Login = {
          HandlePowerKey = "ignore";
          HandleLidSwitch = "ignore";
        };
      };
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
  };

  # ================================
  # PROGRAMS
  # ================================
  programs = {
    thunar.enable = true;
    nix-ld.enable = true;
  };

  # ================================
  # SYSTEM PACKAGES
  # ================================
  environment.systemPackages = with pkgs; [
    inputs.prismlauncher-cracked.packages.${pkgs.system}.prismlauncher
    thunar-archive-plugin
    thunar-volman
    firefox
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
    imv
    pavucontrol
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
    thunderbird
    deluge
    distrobox
    qemu-utils
    virt-viewer
    usbutils
    woeusb-ng
    ntfs3g
    discord
    nodejs_24
    scrcpy
    amneziawg-tools
    jadx
    jdk25
    wireshark
    telegram-desktop
    swaybg
    codex
  ];

  # ================================
  # SYSTEM CORE
  # ================================
  security.rtkit.enable = true;
  security.pam.services.hyprlock = {};
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
    permittedInsecurePackages = [
      # Add package here
    ];
  };

  system.stateVersion = "25.11";
}
