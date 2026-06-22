let
  # 1. Import the generated npins bootstrap file
  sources = import ./npins;
in
{
  meta = {
    # 2. Tell Colmena to use the Nixpkgs version pinned by npins.
    # Colmena accepts the imported Nixpkgs lambda.
    nixpkgs = import sources.nixpkgs;

    # 3. Expose the pinned 'sources' to all NixOS modules.
    # This lets you reference other pinned tools (like home-manager or sops-nix).
    specialArgs = { inherit sources; };
  };

  # 4. Defaults applied to all managed nodes (optional)
  defaults = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      vim
      git
      curl
    ];

    # Example: If you pinned sops-nix in npins, you could import it globally here:
    # imports = [ "${sources.sops-nix}/modules/sops" ];
  };

  # 5. Define individual machines
  "server-01" = { name, nodes, ... }: {
    deployment = {
      targetHost = "192.168.1.100";
      targetUser = "root";
    };

    imports = [
      ./hosts/server-01.nix
    ];
  };

  "server-02" = { name, nodes, ... }: {
    deployment = {
      targetHost = "192.168.1.101";
      targetUser = "root";
    };

    imports = [
      ./hosts/server-02.nix
    ];
  };
}
