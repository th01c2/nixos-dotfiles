
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
    ./proxy-server.nix
  ];

  # ================================
  # Boot Settings
  # ================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [
    "v4l2loopback"
  ];

  # Ensure boot is marked successful
  boot.initrd.systemd.enable = true;
  boot.bootspec.enable = true;
 
  # Kernel parameters for AMD Vega 8 stability
  boot.kernelParams = [
    "amd_pstate=active"  # Enables modern AMD CPU scaling for better performance & efficiency
    "nvme.noacpi=1"      # Prevents NVMe controller hangs caused by buggy ACPI tables
    "amdgpu.dc=1"        # Enables AMD Display Core (Wayland, VRR, HDR, multi-display support)
    "i8042.nomux"        # Fixes laggy or unresponsive touchpad/keyboard issues
  ];

  
  # ================================
  # Graphics Settings (AMD)
  # ================================
  hardware.graphics = {
    enable = true;
    enable32Bit = false;
    extraPackages = with pkgs; [
      libvdpau-va-gl     # VA-API to VDPAU wrapper for video decode
      libva              # Video Acceleration API support
      libva-vdpau-driver # VDPAU backend for VA-API
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
  networking.firewall.allowedTCPPorts = [ 57307 ];
  networking.firewall.allowedUDPPorts = [ 19132  2222 ];

  #  networking.nameservers = [ "1.1.1.1" "1.0.0.1"];

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
  # Users
  # ================================
  users.users.sebastian = {
    isNormalUser = true;
    description = "Sebastian";
    extraGroups = [ "networkmanager" "wheel" "git" "android-tools" "storage" "input" "libvirtd" "docker"];
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
      command = "tuigreet --time --remember --cmd start-hyprland";
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
  programs.fish.enable = true;
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
    file-roller  	    # GUI archive manager for extracting/creating archives
    file                    # Identify file types and MIME types
    vim
    fastfetch		    # Displays system info (CPU, GPU, OS, RAM, etc)
    p7zip		    # 7z compression format support
    unrar		    # Extract RAR archives
    unzip		    # Extract ZIP archives
    android-tools           # ADB and Fastboot for Android device control
    foot                    # GPU-accelerated terminal emulator
    ffmpeg                  # Media encoding, decoding, and conversion tool
    git                     # Version control system
    git-repo
    curl		    # Download files from URLs via CLI
    wget		    # Alternative CLI file downloader
    tuigreet     	    # Text-based login manager
    hyprland                # Wayland compositor/window manager
    imv                     # Lightweight image viewer
    libnotify               # Desktop notification system
    hyprpolkitagent	    # Polkit authentication agent for sudo prompts
    mpv                     # Lightweight video/audio player
    pavucontrol             # Pulseaudio volume control GUI
    payload-dumper-go       # Extract Android firmware images
    zip                     # Create and compress ZIP archives
    texliveFull		    # LaTeX document preparation system for PDFs
    android-studio	    # Android app development IDE
    deluge		    # Torrent client for downloading torrents
    thunderbird		    # Email and calendar client
    wasistlos		    # WhatsApp messaging client
    apktool		    # Decompile and repackage Android APK files
    blender		    # 3D modeling, animation, and rendering software
    distrobox               # Run other Linux distros in containers
    woeusb-ng               # Create Windows bootable USB drives
    ntfs3g                  # Read/write NTFS filesystem support
    apksigner               # Sign and verify Android APK files
    qemu-utils              # QEMU disk image utilities and converters
    simg2img                # Convert Android sparse images to regular images
    python3                 # Python 3 programming language runtime
    virt-viewer
    usbutils
    chromium
    frida-tools
    mission-center
    bottles
    unityhub
    kdePackages.kdenlive
    audacity
    remmina
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
  # Disable Podman and Enable Docker
  virtualisation.podman.enable = false; 
  virtualisation.docker.enable = true;

  # Force the OCI module to use the docker daemon
  virtualisation.oci-containers.backend = "docker";

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  virtualisation.oci-containers.containers."mc-bedrock" = {
    image = "itzg/minecraft-bedrock-server";
    autoStart = false;
     ports = [
    "19132:19132/udp" # Default Bedrock port
    "2222:2222"       # <--- ADD THIS LINE (TCP for SSH)
  ];
     environment = {
      EULA = "TRUE";                    # Required to accept Minecraft EULA
      VERSION = "1.20.80.05";           # Exact version you want
      SERVER_NAME = "My 1.20.80 Bedrock Server";
      GAMEMODE = "survival";
      DIFFICULTY = "normal";
      VIEW_DISTANCE = "8";
      TICK_DISTANCE = "4";
      ALLOW_CHEATS = "false";
      MAX_PLAYERS = "2";
      SERVER_PORT = "19132";
      SERVER_PORTV6 = "19133";          # IPv6 port (optional)
      LEVEL_TYPE = "DEFAULT";
      MAX_THREADS="8";
      ONLINE_MODE = "false";             # Set to false for offline/cracked if needed
      ENABLE_SSH = "true";
    };
    volumes = [
      "/var/lib/minecraft-bedrock:/data" # Persistent data path
    ];
  };

  # ================================
  # SSH config
  # ================================

 /* services.openssh = {
  enable = true;
  settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
    PubkeyAuthentication = true;
    PermitEmptyPasswords = false;
    X11Forwarding = false;
    HostbasedAuthentication = false;
    ChallengeResponseAuthentication = false;
    KbdInteractiveAuthentication = false;
    LogLevel = "VERBOSE";
    MaxAuthTries = 3;
    MaxSessions = 10;
    ClientAliveInterval = 300;
    ClientAliveCountMax = 2;
    AllowTcpForwarding = true;
    HostKeyAlgorithms = "ssh-ed25519";
    AllowUsers = [ "sebastian" ];
  };
};
*/

  # ================================
  # State Version
  # ================================
  system.stateVersion = "24.11"; # Never change THIS property
}
