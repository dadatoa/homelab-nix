{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ../settings.nix
    ../administration.nix
    ../localisation.nix
    ../remote_access.nix
    ../users/default_user.nix
  ];
  
  # Bootloader.
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
  
  ## enable wifi with wpa_supplicant
  networking.wireless.enable = true;
}
