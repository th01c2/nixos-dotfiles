{ config, pkgs, inputs, lib, ... }:
{
  # ================================
  # IMPORTS
  # ================================
  imports = [
    ./hardware-configuration.nix
    ./bash_configuration.nix
    ./sway.nix
    ../config/themes/stylix.nix
  ];

  # ================================
  # BOOT CONFIGURATION
  # ================================
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Use standard latest kernel, optimized via hostPlatform below
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

  # Enable the CUPS printing service
  # services.printing.enable = true;

  # Declaratively add the remote printer
  # hardware.printers.ensurePrinters = [
  #  {
  #    name = "EPSON_L3230_Series";
  #    location = "Network Printer";
  #    description = "Epson L3230 Series (WiFi)";
  #    deviceUri = "ipp://192.168.1.1:631/printers/EPSON_L3230_Series";
  #    model = "everywhere";
  #  }
  #];
  
  #systemd.services.ensure-printers = {
  #  after = [ "network-online.target" ];
  #  wants = [ "network-online.target" ];
  #};
  
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
      wifi.powersave = true; # Saves battery when WiFi is idle
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
  # SYSTEMD SERVICES (AmneziaWG)
  # ================================
  #systemd.services.awg-wg0 = {
  #  description = "AmneziaWG tunnel wg0";
  #  after = [ "network-online.target" ];
  #  wants = [ "network-online.target" ];
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig = {
  #    Type = "oneshot";
  #    RemainAfterExit = true;
  #    ExecStart = "${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amnezia/wg0.conf";
  #    ExecStop = "${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amnezia/wg0.conf";
  #  };
  #};

  # ================================
  # POWER MANAGEMENT & LAPTOP
  # ================================
  powerManagement.enable = true;

  # Auto-cpufreq handles frequency scaling
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "schedutil"; # Balanced performance on battery
        turbo = "auto";         # Allow turbo boosting for snappy response
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  # Essential laptop services
  services.thermald.enable = true; # Prevents overheating throttling
  services.upower.enable = true;   # Required for Waybar battery module
  services.fstrim.enable = true;   # SSD longevity and performance

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
    
    # Must be disabled to prevent conflicts with auto-cpufreq
    power-profiles-daemon.enable = false;

    logind = {
      settings = {
        Login = {
          HandlePowerKey = "ignore";
          HandleLidSwitch = "ignore"; # Do nothing when laptop lid is closed
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
  # VIRTUALIZATION
  # ================================
  # virtualisation = {
  #   docker.enable = true;
  #   libvirtd = {
  #     enable = true;
  #     qemu = {
  #       package = pkgs.qemu_kvm;
  #       runAsRoot = true;
  #       swtpm.enable = true;
  #     };
  #   };
  # };

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
    librewolf
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
    ffmpeg
    imv
    mpv
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
