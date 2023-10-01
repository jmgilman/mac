{...}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "fzf"
      ];
      theme = "";
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      aws-vault-cred = "${aws-vault-cred}";
      aws-vault-add = "${aws-vault-add}";
      aws-vault-add-mfa = "${aws-vault-add-mfa}";
      brg = "batgrep";
      cat = "bat --paging=never";
      cdr = "cd $(git rev-parse --show-toplevel)";
      count = "find . -type f | wc -l";
      ct = "column -t";
      d = "docker";
      da = "direnv allow";
      dr = "direnv reload";
      dp = "docker container prune -f && docker image prune -af";
      fix-ssh = "export SSH_AUTH_SOCK=/run/user/1000/ssh-agent";
      fix-yubi = ''gpg-connect-agent "scd serialno" "learn --force" /bye'';
      g = "git";
      gpb = ''git push origin "$(git rev-parse --abbrev-ref HEAD)"'';
      h = "helm";
      k = "kubectl";
      left = "ls -t -1";
      ls = "exa";
      ll = "exa -la";
      lt = "exa --tree";
      mount = "mount | grep -E ^/dev | column -t";
      new-repo = "gh repo create --public --template jmgilman/template --clone";
      now = ''date +"%T"'';
      nr = "sudo nixos-rebuild switch --flake ~/code/nixos#Office && source ~/.zshrc";
      ports = "sudo lsof -iTCP -sTCP:LISTEN -n -P";
      reload = "source ~/.zshenv; source ~/.zshrc";
      t = "tmux";
      ta = "tmux attach";
      tf = "terraform";
      tg = "terragrunt";
      tl = "tmux ls";
      today = ''date +"%d-%m-%Y"'';
      tree = "broot";
      vi = "vim";
    };

    plugins = [
      {
        name = "you-should-use";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-you-should-use";
          rev = "1.7.3";
          sha256 = "/uVFyplnlg9mETMi7myIndO6IG7Wr9M7xDFfY1pG5Lc=";
        };
      }
    ];

    # Extra environment variables
    envExtra = ''
    '';

    # Extra content for .envrc
    initExtra = ''
      # Setup starship
      #eval "$(starship init zsh)"

      #export PATH="''${PATH}:''${HOME}/.krew/bin"
      #export PATH="''${PATH}:''${HOME}/.bin"
      #export PATH="''${PATH}:''${HOME}/.local/bin"
    '';
  };
}
