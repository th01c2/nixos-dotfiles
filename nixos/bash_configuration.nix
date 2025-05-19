{ config, pkgs, ... }:

{
    programs.bash.shellAliases = {
      rbs = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
    };
}
