{
  self,
  config,
  ...
}: {
  flake = {
    darwinModules = {
      home = {
        home-manager.users.josh = {pkgs, ...}: {
          imports = [
            self.homeModules.common
          ];
        };
      };

      default.imports = [
        self.darwinModules.home-manager
        self.darwinModules.home
      ];
    };
  };
}
