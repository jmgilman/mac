{...}: {
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "23.05";
        imports = [
          ./packages.nix
        ];
      };
    };
  };
}
