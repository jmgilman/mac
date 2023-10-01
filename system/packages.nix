{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    curl
    git
    nano
    wget
    zip
  ];

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = false;
  programs.zsh.enable = true;
}
