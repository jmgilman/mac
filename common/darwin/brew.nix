{pkgs, ...}: {
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    casks = [
      "visual-studio-code"
    ];
  };
}
