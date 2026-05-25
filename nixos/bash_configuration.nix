{ config, pkgs, ... }:

{
  programs.bash.shellInit = ''
    echo -e "\e[32mnixos@10.0.0.1 - Amnezia\e[0m"
    echo -e "\e[32mmihai@10.0.0.2 - Mihai\e[0m"
    echo -e "\e[32mroot@192.168.1.1 - Openwrt\e[0m"
    echo -e "\e[32mroot@192.168.1.5 - DockerServer\e[0m"
    echo -e "\e[32mroot@192.16.100.45:8006 - Proxmox\e[0m"
    echo -e ""
  '';

  programs.fish.shellInit = ''
    echo -e "\e[32mnixos@10.0.0.1 - Amnezia\e[0m"
    echo -e "\e[32mmihai@10.0.0.2 - Mihai\e[0m"
    echo -e "\e[32mroot@192.168.1.1 - Openwrt\e[0m"
    echo -e "\e[32mroot@192.168.1.5 - DockerServer\e[0m"
    echo -e "\e[32mroot@192.16.100.45:8006 - Proxmox\e[0m"
    echo -e ""
  '';

  programs.bash.shellAliases = {
    rbs = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
  };
  programs.fish.shellAliases = {
    rbs = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
  };
}
