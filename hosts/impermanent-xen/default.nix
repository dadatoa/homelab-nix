{ pkgs, lib, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./disko.nix
      ./preservation.nix
      ../../modules/remote_access.nix
      ../../modules/profiles/xen_dom0.nix
    ];

  # DO NOT TOUCH
  system.stateVersion = "26.05";
  boot.kernelParams = 
  [
    ### xen special boot kernel param
    ### hide pci device wifi from dom0 to be abble to pass it on anther damain
    # "xen-pciback.hide=(03:00.0)"
    "intel_iommu=on"
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.systemd-boot.consoleMode = "0";
  boot.loader.efi.canTouchEfiVariables = true;
  ## use latest kernel available
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # to disable "A start job is running for /dev/tpmrm0" timeout
  systemd.tpm2.enable = false;
  # if the previous one is not enough:
  boot.initrd.systemd.tpm2.enable = false;


  # boot.loader.systemd-boot.netbootxyz.enable = true;

  users.users.root = {
    # hashedPasswordFile = "/run/secrets/root-password.txt"; 
    initialHashedPassword = lib.strings.fileContents /run/secrets/root-password.txt;
  };
  users.users.operateur = {
    extraGroups = [ "wheel" ];
    };

  security.sudo.wheelNeedsPassword = false;
  
  networking.hostName = "xen";
  
  networking.firewall.enable = false;
  ## manage network with systemd
  networking.useNetworkd = true;
  systemd.network.enable = true;
  systemd.network = {
    netdevs = {  ## declare virtual devices
      "20-xenbr0" = { # bridge
        netdevConfig = {
          Kind = "bridge";
          Name = "xenbr0";
          Description = "xen default bridge";
        };
      };
    #   "20-vlan66" = { # vlan
    #     netdevConfig = {
    #       Kind = "vlan";
    #       Name = "vlan66";
    #       Description = "LAN Access";
    #     };
    #     vlanConfig = {
    #       Id = 66;
    #     };
    #   };
    };
    networks = { ## network interfaces configurations
      "30-lan" = {
        enable = true;
        matchConfig.Name = "enp2s0";
        networkConfig.DHCP = "ipv4";
        networkConfig.Bridge = "xenbr0";
      };

      "40-xenbr0" = {
        matchConfig.Name = "xenbr0";
        networkConfig.DHCP = "ipv4";
      };
    };
  };
}

