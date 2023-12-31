{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
  };

  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin"];

      imports = [
        inputs.nixos-flake.flakeModule
        ./home
        ./system
      ];

      flake = {
        darwinConfigurations.studio = self.nixos-flake.lib.mkMacosSystem {
          nixpkgs.hostPlatform = "aarch64-darwin";
          imports = [
            ./hosts/office
            self.systemModules.default
          ];
        };
      };
    };
}
