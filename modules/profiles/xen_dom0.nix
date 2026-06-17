{ pkgs, ... }:
{
  imports =
    [
      # ./nixos_bm.nix
    ];
  ###
  ### Xen project boot options
  ###
  boot.initrd.systemd.enable = true;
  ## for booting xen 
  boot.initrd.kernelModules = 
  [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];
  ############################
  ############################
  ############################


  virtualisation.xen =
  {
    enable = true;
    boot.builderVerbosity = "info";
    ## Adds a handy report that lets you know which Xen boot entries were created.
     
    boot.params = 
    [
      "vga=ask"
      "dom0=pvh" # Uses the PVH virtualisation mode for the Domain 0, instead of PV.
    ];
    dom0Resources =
    {
      memory = 1024; # Only allocates 1GiB of memory to the Domain 0, with the rest of the system memory being freely available to other domains.
      maxVCPUs = 2; # Allows the Domain 0 to use, at most, two CPU cores.
    };
  };

  ## aditionnal packages
  environment.systemPackages = with pkgs; [
    qemu_xen
    grub2_xen
    grub2_xen_pvh
    grub2_pvhgrub_image
    grub2
  ];
}
