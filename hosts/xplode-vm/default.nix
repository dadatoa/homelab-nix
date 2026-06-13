{ config, pkgs, lib, ... }:
{
  
  imports = [
    ../../modules/profiles/xen_domU.nix
    ../../modules/remote_access.nix
    ./preservation.nix
    ./disko.nix
    # ./services.nix
  ];

  system.stateVersion = "26.05";

  environment.systemPackages = with pkgs; [
  ];
  
  users.users.root = {
    # hashedPasswordFile = "/run/secrets/root-password.txt"; 
    hashedPasswordFile = "/run/secrets/root-password.txt";
  };
  
  # add podman to test cockpit-podman
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
    };
  };

  networking.hostName = "xplode";
  
  networking.firewall.enable = false; 
  
  ## manage network with systemd
  networking.useNetworkd = true;
  systemd.network.enable = true;
  systemd.network.networks = {
    "30-lan" = {
      matchConfig.Name = "enX0";
      networkConfig.DHCP = "ipv4";
    };
  };
  
  services.glusterfs.enable = true;

  # fileSystems."/srv" = 
  # {
  #   device = "/dev/xvdd1";
  #   fsType = "btrfs";
  # };
}
