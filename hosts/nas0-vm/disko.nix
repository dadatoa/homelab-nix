{ device ? throw "Set this to your disk device, e.g. /dev/sda", ... }:
{
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persistent".neededForBoot = true; # sometimes needed too
  fileSystems."/boot".neededForBoot = true;
  disko.devices.nodev = {
    "/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=25%"
        "mode=755"
      ];
    };
  };

  disko.devices.disk.main = {
    inherit device;
    type = "disk";

    content.type = "gpt";

    content.partitions.root = {
      name = "root";
      size = "100%";

      content = {
        type = "btrfs";
        extraArgs = ["-f"];

        subvolumes = {
          "/persistent" = {
            mountOptions = ["subvol=persistent" "noatime"];
            mountpoint = "/persistent";
          };

          "/nix" = {
            mountOptions = ["subvol=nix" "noatime"];
            mountpoint = "/nix";
          };
          "/boot" = {
            mountOptions = ["subvol=boot" "noatime"];
            mountpoint = "/boot";
          };
        };
      };
    };
  };
}
