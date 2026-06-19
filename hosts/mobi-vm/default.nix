{ config, pkgs, lib, ... }:
{
  
  imports = [
    ../../modules/profiles/xen_domU.nix
    ../../modules/remote_access.nix
    ./preservation.nix
    ./fs.nix
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
  virtualisation.containers.enable = true;
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless.enable = true;
    rootless.setSocketVariable = true;
    # daemon.settings.data-root = "/some-place/to-store-the-docker-data";
  };

  networking.hostName = "mobi";
  
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
