{...}: {
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "23.05";
        imports = [
          ./bat.nix
          ./direnv.nix
          ./git.nix
          ./gpg.nix
          ./navi.nix
          ./packages.nix
          ./starship.nix
          ./tmux.nix
          ./zsh.nix
        ];
      };
    };
  };
}
