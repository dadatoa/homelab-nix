{
  preservation = {
    enable = true;

    preserveAt."/persistent" = {
      directories = [
        "/etc/nixos"
        # "/var/lib/bluetooth"
        "/var/lib/tailscale"
        "/var/lib/glusterd"
        { directory = "/var/lib/nixos"; inInitrd = true; }
      ];

      files = [
        "/etc/ssh/authorized_keys.d/operateur"
        { file = "/persistent/secrets/root-password.txt"; inInitrd = true; }
        { file = "/persistent/secrets/ts-key.txt"; inInitrd = true; }
        { file = "/etc/machine-id"; inInitrd = true; }
      ];

      # Preserve user files
      users.operateur = {
        directories = [ ".ssh" ];
        files = [ ".gitconfig" ];
      };
      users.root = {
        home = "/root";
        directories = [ ];
        files = [ ".gitconfig" ];
      };
    };
  };
}
