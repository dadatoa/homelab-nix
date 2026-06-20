let
  sources = import ./npins;
in

{
  meta = {
    # 1. Use the pinned nixpkgs source folder from npins
    nixpkgs = import sources.nixpkgs {
      stdenv.hostPlatform.system = "x86_64-linux";
      config = {};
      overlays = [];
    };
    
    # 2. Pass npins references to nodes via special arguments
    specialArgs = { inherit sources; };
  };

  # 3. Apply settings universally across all nodes
  defaults = {
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
      nixPath = [ "nixpkgs=${sources.nixpkgs}" ];
    };
    deployment.buildOnTarget = true;

  };

  # 4. Target Node Settings
  xplode = { name, nodes, ... }: {
    imports = [
      ./hosts/xplode-vm
    ];
    deployment = {
      # Allow local deployment with `colmena apply-local`
      allowLocalDeployment = true;
      # Disable SSH deployment. This node will be skipped in a
      # normal`colmena apply`.
      # targetHost = null;
      targetHost = "xplode.blue-edmontosaurus.ts.net";
      targetUser = "operateur";
      tags = [ "domu" ];
    };
  };

  xen = { name, nodes, ... }: {
    deployment = {
      targetHost = "xen.blue-edmontosaurus.ts.net";
      targetUser = "operateur";
      tags = [ "dom0" "remote" ];
    };
    imports = [
      ./hosts/impermanent-xen
    ];
  };
}
