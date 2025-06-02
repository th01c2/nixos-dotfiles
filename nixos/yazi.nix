{ config, pkgs, ... }:

  programs.yazi.enable = true;
{
  environment.systemPackages = with pkgs; [
	yaziPlugins.sudo
	yaziPlugins.ouch
	yaziPlugins.diff
	yaziPlugins.rsync
	yaziPlugins.chmod
	yaziPlugins.restore
	yaziPlugins.git
	
  ];
}
