{ config, pkgs, ... }:

{
  # 1. Enable the Shadowsocks-Rust server
  services.shadowsocks-rust = {
    enable = true;
    address = "0.0.0.0";
    port = 8388; # You can change this, but keep it the same on the client
    passwordFile = "/etc/shadowsocks-password"; # Create this file with a password inside
    encryptionMethod = "chacha20-ietf-poly1305"; # Strong and hard to detect
  };

  # 2. Open the port in your firewall
  networking.firewall.allowedTCPPorts = [ 8388 ];
  networking.firewall.allowedUDPPorts = [ 8388 ];
}
