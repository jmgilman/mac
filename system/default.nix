{self, ...}: {
  flake = {
    systemModules = {
      common = {
        imports = [
          ./brew.nix
          ./gpg.nix
          ./macos.nix
          ./nix.nix
          ./packages.nix
        ];
      };
      home = {
        home-manager.users.josh = {pkgs, ...}: {
          imports = [
            self.homeModules.common # see home/default.nix
          ];
        };
      };

      default.imports = [
        self.darwinModules.home-manager # sane defaults from nixos-flake
        self.systemModules.home
        self.systemModules.common
      ];
    };
  };
}
