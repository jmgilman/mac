{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        user = "jmgilman";
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519_office";
      };
      work = {
        user = "josh";
        hostname = "work.gilman.io";
        identityFile = "~/.ssh/id_ed25519_office";
      };
    };
  };
}
