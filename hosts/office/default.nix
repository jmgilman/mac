{pkgs, ...}: {
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = "nix-command flakes auto-allocate-uids";
    extra-nix-path = "nixpkgs=flake:nixpkgs";
    trusted-users = ["root" "josh"];
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    casks = [];
  };
}
