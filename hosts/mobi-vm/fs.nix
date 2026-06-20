{
  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "size=25%" "mode=755" ]; # mode=755 so only root can write to those files
    };

  fileSystems."/nix" = {
    neededForBoot = true;
    device = "/dev/disk/by-uuid/32b18bfa-0240-4b6a-ae79-0d00937d53a8";
    fsType = "btrfs";
    mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
  };
  fileSystems."/persistent" = {
    neededForBoot = true;
    device = "/dev/disk/by-uuid/32b18bfa-0240-4b6a-ae79-0d00937d53a8";
    fsType = "btrfs";
    mountOptions = ["subvol=persistent" "compress=zstd" "noatime"];
  };
  fileSystems."/boot" = {
    neededForBoot = true;
    device = "/dev/disk/by-uuid/32b18bfa-0240-4b6a-ae79-0d00937d53a8";
    fsType = "btrfs";
    mountOptions = ["subvol=boot" "noatime"];
  };

  swapDevices = [{ 
    device = "/swap/swapfile"; 
    size = 8*1024; # Creates an 8GB swap file 
  }];
}
