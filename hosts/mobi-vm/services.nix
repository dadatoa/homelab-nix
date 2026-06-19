{ config, lib, pkgs, ... }:
{
  systemd.user.services.chezmoi = {
    description = "Init config at boot";
    after = [ "multi-user.target" ];  # Optional: specify dependencies
    wantedBy = [ "default.target" ];  # Run at boot
    path = [
      pkgs.chezmoi
      pkgs.git
    ];
    script = ''
      chezmoi init --apply https://github.com/dadatoa/dots.git
    '';
    serviceConfig = {
      Type = "oneshot";  # The script runs once and finishes
    };
  };
}
