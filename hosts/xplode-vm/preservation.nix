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
        { file = "/run/secrets/root-password.txt"; inInitrd = true; }
        { file = "/run/secrets/ts-key.txt"; inInitrd = true; }
        { file = "/etc/machine-id"; inInitrd = true; }
      ];

      # Preserve user files
      users.operateur = {
        directories = [
          ".ssh"
          # ".local/share/chezmoi"
      #     ".mozilla"
        ];
      #
      #   files = [
      #
      #   ];
      };
      users.root = {
        home = "/root";
        directories = [
          # ".local/share/chezmoi"
        ];
      #   files = [ ".gitconfig" ];
      };
    };
  };
}
