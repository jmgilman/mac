{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        user = "jmgilman";
        hostname = "github.com";
        identitifyfile = "~/.ssh/id_ed25519_office";
      };
      work = {
        user = "josh";
        hostname = "work.gilman.io";
        identityfile = "~/.ssh/id_ed25519_office";
      };
    };
  };
  services.ssh-agent.enable = true;
}
