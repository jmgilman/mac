{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "jmgilman";
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519_studio";
      };
      work = {
        user = "josh";
        hostname = "work.gilman.io";
        identityFile = "~/.ssh/id_ed25519_studio";
      };
    };
  };
}
