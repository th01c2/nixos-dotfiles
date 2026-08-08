# --- Additions for streamllm iGPU (Radeon 780M / gfx1103) compute ---
# Splice these into your existing configuration.nix; don't replace
# your hardware.graphics / environment.systemPackages blocks, merge into them.

{ config, pkgs, lib, ... }:

{
  # Vulkan compute (RADV) is the recommended path for gfx1103 — solid,
  # no override env vars needed. hardware.graphics.enable = true (already
  # in your config) ships Mesa RADV by default; this just adds the
  # dev/diagnostic tooling on top.
  hardware.graphics.extraPackages = with pkgs; [
    vulkan-loader
    mesa.opencl        # rusticl OpenCL over RADV, useful if a tool wants CL instead of Vulkan
  ];

  environment.systemPackages = with pkgs; [
    vulkan-tools           # vulkaninfo — confirm RADV + gfx1103 show up
    vulkan-validation-layers
    clinfo                 # confirm OpenCL device enumeration
    # --- ROCm: optional, experimental on this chip. Uncomment to try HIP:
    # rocmPackages.clr
    # rocmPackages.rocminfo
  ];

  # If you do try ROCm later, this env var is the classic gfx1103 workaround —
  # known to be unstable for some compute kernels (MIOpen conv ops hang as of
  # mid-2026). Vulkan doesn't need this at all.
  # environment.sessionVariables.HSA_OVERRIDE_GFX_VERSION = "11.0.0";

  # GPU access permissions — you're missing these groups currently.
  users.users.sebastian.extraGroups = [ "video" "render" ];

  # GTT (system-RAM-as-GPU-memory) size cap. Default (-1/auto) is already
  # ~3/4 of total RAM on an APU like this (~24GB on your 32GB box) — there
  # is no true "unlimited" value, only how high you set the cap. It's a
  # ceiling the driver is allowed to borrow into dynamically, not a
  # reservation taken up front, so setting it high costs nothing until
  # the GPU actually allocates that much.
  #
  # Old param (works with a deprecation warning on recent kernels):
  # boot.kernelParams = [ "amdgpu.gttsize=28672" ];  # MB
  #
  # New param (pages, 4KB each: MB * 256). Equivalent to 28GB:
  # boot.kernelParams = [ "ttm.pages_limit=7340032" ];
  #
  # Leave ~4GB headroom below your 32GB total for the OS/desktop —
  # don't set this to the full 32768.
}
