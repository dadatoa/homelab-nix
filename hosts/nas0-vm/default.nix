{ config, pkgs, lib, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  imports = [
    ../../modules/profiles/xen_domU.nix
    ./preservation.nix
    ./disko.nix
    ./remote_access.nix
    # ./services.nix
  ];

  system.stateVersion = "26.05";

  environment.systemPackages = with pkgs; [
  ];
  
  users.users.root = {
    hashedPasswordFile = "/run/secrets/root-password.txt"; 
    # initialHashedPassword = lib.strings.fileContents /run/secrets/root-password.txt;
  };
  
  # add podman to test cockpit-podman
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
    };
  };

  networking.hostName = "nas0";
  
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
