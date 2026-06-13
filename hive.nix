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
    ];
  };

  # 4. Target Node Settings
  xplode = { name, nodes, ... }: {
    deployment = {
      targetHost = "xplode";
      targetUser = "root";
      tags = [ "prod" "web" ];
    };
    imports = [
      ./hosts/xplode-vm
    ];
    # Configure the machine to respect the npins pin natively
    nix = {
      channel.enable = false;
      nixPath = [ "nixpkgs=${sources.nixpkgs}" ];
    };

  };
}

