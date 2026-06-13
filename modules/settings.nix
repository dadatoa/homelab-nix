{ config, lib, pkgs, inputs, ... }:
{
  nix = {
    optimise.automatic = true;

    settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

  };

  # Set your time zone.
  time.timeZone = "Asia/Bangkok";

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

}
