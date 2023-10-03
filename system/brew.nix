{pkgs, ...}: {
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    casks = [
      "1password"
      "discord"
      "element"
      "hyperkey"
      "iterm2"
      "logseq"
      "microsoft-remote-desktop"
      "multipass"
      "orbstack"
      "postman"
      "readdle-spark"
      "signal"
      "slack"
      "snagit"
      "spotify"
      "steam"
      "visual-studio-code"
      "vivaldi"
      "zoom"
    ];
  };
}
