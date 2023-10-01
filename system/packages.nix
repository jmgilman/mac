{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    curl
    git
    nano
    wget
    zip
  ];
}
