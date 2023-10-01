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

      "*" = {
        forwardagent = false;
        compression = false;
        serveraliveinterval = 0;
        serveralivecountmax = 3;
        hashknownhosts = false;
        userknownhostsfile = "~/.ssh/known_hosts";
        controlmaster = false;
        controlpath = "~/.ssh/master-%r@%n:%p";
        controlpersist = false;
      };
    };
  };
  services.ssh-agent.enable = true;
}
