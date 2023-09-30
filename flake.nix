{
  description = "MacOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin"; # newest version as of may 2023, probably needs to get updated in november
    home-manager.url = "github:nix-community/home-manager/release-23.05"; # ...
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...
  };

  # add the inputs declared above to the argument attribute set
  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
  }: {
    darwinConfigurations."office" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [./hosts/office/default.nix];
    };
  };
}
