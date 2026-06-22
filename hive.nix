let
  sources = import ./npins;
in

{
  meta = {
    # 1. Use the pinned nixpkgs source folder from npins
    nixpkgs = import sources.nixpkgs {
    };
    # 2. Pass npins references to nodes via special arguments
    specialArgs = { inherit sources; };
  };

  # 3. Apply settings universally across all nodes
  defaults = { config, pkgs, sources, ... }:
    let
  # Initialize the unstable package set for this host's specific system architecture
    unstable = import sources.nixpkgs-unstable {
      system = pkgs.system;
      config = {
        # Allow unfree packages if needed (e.g., vscode, steam, etc.)
        allowUnfree = true;
      };
    };
    in
    {
    nixpkgs.hostPlatform.system = "x86_64-linux";
    imports = [
      (sources.disko + "/module.nix")
      (sources.preservation + "/module.nix")
      ./modules/administration.nix
      ./modules/localisation.nix
      ./modules/settings.nix
      ./modules/usefull_tools.nix
      ./modules/users
      ./modules/remote_access.nix
    ];
    # Configure all machines to respect the npins pin natively
    nix = {
      channel.enable = false;
    };
    deployment.buildOnTarget = true;
    environment.systemPackages = [
      unstable.pkgs.tailscale
    ];
  };

  # 4. Target Node Settings
  deckard = { name, nodes, ... }: {
    imports = [
      ./hosts/deckard
    ];
    deployment = {
      # Allow local deployment with `colmena apply-local`
      allowLocalDeployment = true;
      # Disable SSH deployment. This node will be skipped in a
      # normal`colmena apply`.
      # targetHost = null;
      targetHost = "deckard.blue-edmontosaurus.ts.net";
      targetUser = "operateur";
      tags = [ "domu" ];
    };
  };

  xen = { name, nodes, ... }: {
    deployment = {
      targetHost = "xen.blue-edmontosaurus.ts.net";
      targetUser = "operateur";
      tags = [ "dom0" ];
    };
    imports = [
      ./hosts/impermanent-xen
    ];
  };
}
