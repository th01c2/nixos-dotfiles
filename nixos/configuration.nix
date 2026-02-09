{ config, pkgs, inputs, lib, ... }:

{
  # ================================
  # IMPORTS
  # ================================
  imports = [
    ./hardware-configuration.nix
    ./bash_configuration.nix
    ./build-tools.nix
    ./android-env.nix
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

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    bootspec.enable = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  # ================================
  # HARDWARE
  # ================================
  hardware.graphics = {
    enable = true;
    enable32Bit = false;
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
    memoryPercent = 50;
  };

  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
    priority = 10;
  }];

  # ================================
  # SYSTEM IDENTITY & LOCALIZATION
  # ================================
  networking.hostName = "nixos-sebastian";                   # Set your hostname
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
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 57307 8388 ];                   # Port 22 for SSH
      allowedUDPPorts = [ 19132 8388 41641 ];                # Port 41641 for Tailscale direct

      # THE FIX: Allow Tailscale to work properly on NixOS
      trustedInterfaces = [ "tailscale0" ];                  # Trust virtual tunnel traffic
      checkReversePath = "loose";                            # Allow non-standard routing
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

    tailscale.enable = true;                                 # Tailscale service
    openssh = {
      enable = true;                                         # SSH service
      settings = {
        PasswordAuthentication = true;                       # Allow passwords for now
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
    firefox.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    };
    fish.enable = true;
  };

  # ================================
  # SYSTEM PACKAGES
  # ================================
  environment.systemPackages = with pkgs; [
    inputs.prismlauncher-cracked.packages.${pkgs.system}.prismlauncher
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
    vesktop
    tailscale
    gimp
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
}
