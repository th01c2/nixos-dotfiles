{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core build tools
    gcc
    clang
    lld
    gnumake
    cmake
    ninja
    ccache
    
    # Cross compilation toolchains
    gcc-arm-embedded
    pkgsCross.aarch64-multiplatform.buildPackages.gcc
    
    # Build dependencies
    bc
    bison
    flex
    openssl
    perl
    python3
    rsync
    
    # Compression tools
    gzip
    bzip2
    lz4
    xz
    zstd
    lzop
    
    # Development tools
    git
    curl
    wget
    
    # Additional utilities
    ncurses
    libelf
    zlib
    elfutils
    
    # Debugging tools
    gdb
  ];
}
