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

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    bootspec.enable = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelParams = [
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];

    consoleLogLevel = 0; 
    initrd.verbose = false;
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
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 57307 8388 ];
      allowedUDPPorts = [19132 8388 41641 ];
      trustedInterfaces = [ "tun0" "tailscale0" ];
      checkReversePath = "loose";
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;

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

    tailscale.enable = true;
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

    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="dialout"
      SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", MODE="0666", GROUP="dialout"
      SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="dialout"
      SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", MODE="0666", GROUP="dialout"
    '';
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
      "video"
      "dialout"
      "audio" 
    ];
  };

  # ================================
  # ANDROID MIC
  # ================================
  systemd.user.services.audiosource = {
    description = "Android Phone Microphone";
    wantedBy = [ "default.target" ];
    environment = {
      AUDIOSOURCE_NAME = "android-source";
    };
    path = with pkgs; [ android-tools pulseaudio python3 bash ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash /home/sebastian/audiosource run";
      Restart = "always";
      RestartSec = "3s";
    };
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
    deluge
    remmina
    freerdp
    distrobox
    qemu-utils
    virt-viewer
    usbutils
    bottles
    texliveFull
    woeusb-ng
    ntfs3g
    mission-center
    vesktop
    tailscale
    mcpelauncher-ui-qt
    nodejs_24
    scrcpy
    nmap
    flclash
    pulseaudio
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    openldap = pkgs.openldap.overrideAttrs (oldAttrs: {
      doCheck = false;
    });
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XWAYLAND_NO_GLAMOR = "0"; 
  };

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
