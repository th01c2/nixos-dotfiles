{ config, pkgs, ... }:
{
  fileSystems."/media/sebastian/ExternalSSD" = {
    device = "UUID=8288-1E5D";
    fsType = "vfat";
    options = [
      "uid=1000"        # Make sure the user ID corresponds to 'sebastian'
      "gid=100"         # Usually 'users' group
      "umask=0022"      # Standard permission mask (rwxr-xr-x)
      "nofail"          # Don't fail boot if the disk is not plugged in
      "x-systemd.automount" # Automount on access (non-blocking)
    ];
  };
}

