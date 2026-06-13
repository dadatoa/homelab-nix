{ config, pkgs, ... }:
{
  users.users.operateur = {
    isNormalUser = true;
    uid = 1000;
    description = "main user";
    extraGroups = [
      "wheel"
      "video"
    ];
    # packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBA52LLKZPhszwrzrqOwLJ2a2spNzjAn/ls6krE9SM/i dadatoa@dadabook"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnWrIExo7hWe04wTUUEn6smnx/LRfNtPtatR+NgQlfz SpaceK@dadabook"
    ];
  };

}
