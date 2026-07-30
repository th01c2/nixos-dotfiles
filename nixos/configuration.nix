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
  ];

  # ================================
  # BOOT CONFIGURATION
  # ================================
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    
    kernelPackages = pkgs.linuxPackages;
    kernelModules = [ "v4l2loopback" "amneziawg" ];
    extraModulePackages = [ 
      config.boot.kernelPackages.v4l2loopback 
      config.boot.kernelPackages.amneziawg
    ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  # ================================
  # HARDWARE
  # ================================
  hardware.graphics = {
    enable = true;
    # disabled for steam - enable32Bit = false;
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

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  # Enable the CUPS printing service
  services.printing.enable = true;

  # Declaratively add the remote printer
  hardware.printers.ensurePrinters = [
    {
      name = "EPSON_L3230_Series";
      location = "Network Printer";
      description = "Epson L3230 Series (WiFi)";
      # Use IPP protocol for remote CUPS servers
      deviceUri = "ipp://192.168.1.1:631/printers/EPSON_L3230_Series";
      # "everywhere" tells CUPS to query the remote server for the driver/PPD
      model = "everywhere"; 
    }
  ];

  # Optional: Set it as your default printer
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
    networkmanager.enable = true;
#    interfaces.enp3s0.ipv4.addresses = [{
 #     address = "192.168.1.3";
  #    prefixLength = 24;
   # }];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];                   
      allowedUDPPorts = [ ];                
      
      # Removed tailscale0, added wg0
      trustedInterfaces = [ "tun0" "wg0" ];                  
      checkReversePath = "loose";                            
    };
  };

   networking.nftables.enable = true;

  # ================================
  # SYSTEMD SERVICES (AmneziaWG)
  # ================================
  systemd.services.awg-wg0 = {
    description = "AmneziaWG tunnel wg0";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amnezia/wg0.conf";
      ExecStop = "${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amnezia/wg0.conf";
    };
  };

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
        command = "tuigreet --time --remember --cmd start-hyprland";
        user = "sebastian";
      };
    };

    # Removed tailscale.enable = true;
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
    power-profiles-daemon.enable = true;
    logind.settings.Login.HandlePowerKey = "ignore";
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
  virtualisation = {
    docker.enable = true;
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
  # PROGRAMS
  # ================================
  programs = {
    hyprland.enable = true;
    hyprlock.enable = true;
    thunar.enable = true;
    fish.enable = true;
  };

  programs.nix-ld.enable = true;

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
    hyprpolkitagent
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
    chromium
    thunderbird
    deluge
    remmina
    distrobox
    qemu-utils
    virt-viewer
    usbutils
    texliveFull
    woeusb-ng
    ntfs3g
    mission-center
    discord
    mcpelauncher-ui-qt
    nodejs_24
    scrcpy
    winboat
    amneziawg-tools
    moonlight-qt
    jadx
    jdk25
    antigravity
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
  };

  system.stateVersion = "25.11"; 

 programs.steam = {
  enable = true;
};
}
