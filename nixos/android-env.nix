# FHS environment for building Android (LineageOS, YAAP, etc.)
# Based on: https://gist.github.com/Arian04/bea169c987d46a7f51c63a68bc117472
#
# IMPORTANT: Use a pure shell for builds to work: run `android-env` or `nix-shell --pure`
# Note: The hardened NixOS kernel disables 32-bit emulation which may cause "Exec format error".
# To fix, use the default kernel or enable "IA32_EMULATION y" in the kernel config.

# (sidharthify): for anyone going through my configs, this itself is from https://gist.github.com/mio-19/0877c8ff3b6f26c89e84c2131b15215b

{ pkgs, ... }:

let
  android-fhs = pkgs.buildFHSEnv {
    name = "android-env";
    targetPkgs = pkgs: with pkgs; [
      android-tools
      libxcrypt-legacy # libcrypt.so.1
      freetype         # libfreetype.so.6
      fontconfig       # java NPE: "sun.awt.FontConfiguration.head" is null
      yaml-cpp         # necessary for some kernels

      bc
      binutils
      bison
      ccache
      curl
      flex
      gcc
      git
      git-repo
      git-lfs
      gnumake
      gnupg
      gperf
      imagemagick
      jdk17
      elfutils
      libxml2
      libxslt
      lz4
      lzop
      m4
      nettools
      openssl.dev
      openssl
      perl
      pngcrush
      procps
      python3
      rsync
      schedtool
      SDL
      squashfsTools
      unzip
      util-linux
      xml2
      zip
      zsh
    ];
    multiPkgs = pkgs: with pkgs; [
      zlib
      ncurses5
      libcxx
      readline
      libgcc    # crtbeginS.o
      iconv
      iconv.dev # sys/types.h
    ];
    runScript = "bash";
    profile = ''
      export ALLOW_NINJA_ENV=true
      export USE_CCACHE=1
      export CCACHE_EXEC=/usr/bin/ccache
      export ANDROID_JAVA_HOME=${pkgs.jdk11.home}
      export TMPDIR=/tmp
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.ncurses5}/lib
    '';
  };
in {
  environment.systemPackages = [ android-fhs ];
}
