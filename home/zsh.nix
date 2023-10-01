{pkgs, ...}: let
  # Custom scripts for aws-vault
  aws-vault-cred = pkgs.writeShellScript "aws-vault-cred" ''
    if [[ -z "$1" ]]; then
      echo "error: Missing profile name"
      exit 1
    fi

    # Verify a profile is configured
    if ! aws-vault list --profiles | grep "$1" > /dev/null 2>&1; then
      echo "error: profile $1 has not been configured"
      exit 1
    fi

    # Check for virtual MFA
    mfa=$(aws configure get mfa_serial --profile "$1")

    if [[ ! -z "$mfa" ]]; then
      if ! gopass show -y "aws/mfa-$1" > /dev/null 2>&1; then
        echo "error: profile $1 has MFA configured but has no entry in gopass"
        exit 1
      fi
    fi

    # Return auth details
    if [[ ! -z "$mfa" ]]; then
      aws-vault exec -j -t "$(gopass otp -o aws/mfa-$1)" "$1" 2> /dev/null
    else
      aws-vault exec -j -n "$1" 2> /dev/null
    fi
  '';

  aws-vault-add = pkgs.writeShellScript "aws-vault-add" ''
    if [[ -z "$1" ]]; then
      echo "error: Missing profile name"
      exit 1
    fi

    # Check if profile is already configured
    if aws-vault list --profiles | grep "$1"; then
      read -p "Profile exists; reconfigure it? [y/n] " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
        aws-vault remove -f "$1"
      fi
    fi

    # Ask for authentication details
    echo -n "Access Key ID: "
    read -s AWS_ACCESS_KEY_ID
    echo

    echo -n "Secret Key: "
    read -s AWS_SECRET_ACCESS_KEY
    echo

    # Add credentials
    export AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY
    aws-vault add --env "$1"

    # Configure the profile
    aws configure set credential_process "${aws-vault-cred} $1" --profile "$1"
  '';

  aws-vault-add-mfa = pkgs.writeShellScript "aws-vault-mfa" ''
    if [[ -z "$1" ]]; then
      echo "error: Missing profile name"
      exit 1
    fi

    if [[ -z "$2" ]]; then
      echo "error: Missing username"
      exit 1
    fi

    echo ">>> Registering MFA device..."
    serial=$(aws iam create-virtual-mfa-device \
      --virtual-mfa-device-name gopass \
      --outfile /tmp/creds \
      --bootstrap-method Base32StringSeed | jq -r .VirtualMFADevice.SerialNumber)

    echo ">>> Saving secret key..."
    cat /tmp/creds | gopass insert -f "aws/mfa-$1"
    rm -rf /tmp/creds

    echo ">>> Generating OTP #1..."
    otp1=$(gopass otp -o "aws/mfa-$1")

    echo ">>> Waiting 35 seconds..."
    sleep 35

    echo ">>> Generating OTP #2..."
    otp2=$(gopass otp -o "aws/mfa-$1")

    echo ">>> Attaching MFA..."
    aws iam enable-mfa-device \
      --user-name "$2" \
      --serial-number "$serial" \
      --authentication-code1 "$otp1" \
      --authentication-code2 "$otp2"

    echo ">>> Updating profile..."
    aws configure set mfa_serial --profile "$1" "$serial"

    echo ">>> Done!"
  '';
in {
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
      export AWS_VAULT_BACKEND=pass
      export AWS_VAULT_PASS_CMD=gopass
      export AWS_VAULT_PASS_PASSWORD_STORE_DIR=~/.local/share/gopass/stores/root
      export AWS_VAULT_PASS_PREFIX=aws-vault
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
