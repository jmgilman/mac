{...}: {
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    extraConfig = ''
      StreamLocalBindUnlink yes
      GatewayPorts yes
    '';
  };

  programs.ssh.startAgent = true;

  users.users.josh.openssh.authorizedKeys = {
    keyFiles = [
      ../files/desktop_sshkey
      ../files/mac_sshkey
      ../files/office_sshkey
    ];
  };
}
