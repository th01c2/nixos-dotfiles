{ pkgs, lib, ... }:

let
  zen3Flags = [ "-march=znver3" "-mtune=znver3" ];
in
{
  nixpkgs.overlays = [
    (final: prev: {
      mpv-unwrapped = prev.mpv-unwrapped.overrideAttrs (old: {
        NIX_CFLAGS_COMPILE = toString (old.NIX_CFLAGS_COMPILE or "") + " " + toString zen3Flags;
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    firefox
    (ffmpeg.override { stdenv = pkgs.withCFlags zen3Flags pkgs.stdenv; })
    mpv   # now built on top of the overridden mpv-unwrapped
    (neovim.override { stdenv = pkgs.withCFlags zen3Flags pkgs.stdenv; })
  ];
}
