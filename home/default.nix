{...}: {
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "23.05";
        imports = [
          ./bat.nix
          ./direnv.nix
          ./navi.nix
          ./packages.nix
          ./tmux.nix
          ./zsh.nix
        ];
      };
    };
  };
}
