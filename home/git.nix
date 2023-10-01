{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    aliases = {
      # View abbreviated SHA, description, and history graph of the latest 20 commits
      l = "log --pretty=oneline -n 20 --graph --abbrev-commit";

      # View abbreviated SHA, description, and history graph of the latest 20 commits
      s = "status -s";

      # Show the diff between the latest commit and the current state
      d = "diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat";

      # Pull in remote changes for the current repository and all its submodules
      p = "pull --recurse-submodules";

      # Clone a repository including all submodules
      c = "clone --recursive";

      # Commit all changes
      ca = "!git add -A && git commit -av";

      # Switch to a branch, creating it if necessary
      go = ''!f() { git checkout -b "$1" 2> /dev/null || git checkout "$1"; }; f'';

      # Push current branch
      pb = ''!git push origin "$(git rev-parse --abbrev-ref HEAD)"'';

      # Show verbose output about tags, branches or remotes
      tags = "tag -l";
      branches = "branch -a";
      remotes = "remote -v";

      # List aliases
      aliases = "config --get-regexp alias";

      # Amend the currently staged files to the latest commit
      amend = "commit --amend --reuse-message=HEAD";

      # Interactive rebase with the given number of latest commits
      reb = "!r() { git rebase -i HEAD~$1; }; r";

      # List contributors with number of commits
      contributors = "shortlog --summary --numbered";
    };

    extraConfig = {
      # Detect whitespace errors when applying a patch
      apply.whitespace = "fix";

      # Treat spaces before tabs and all kinds of trailing whitespace as an error
      core.whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";

      # Speed up commands involving untracked files such as `git status`.
      core.untrackedCache = true;

      # Detect copies as well as renames
      diff.renames = "copies";

      # Automatically correct and execute mistyped commands
      help.autocorrect = 1;

      # Make `git push` push relevant annotated tags when pushing branches out.
      push.followTags = true;

      # Use SSH instead of HTTPS
      url."git@github.com:".insteadOf = "https://github.com/";
    };

    # Use delta for generating diffs
    delta = {
      enable = true;
      options = {
        features = "side-by-side line-numbers decorations";
        syntax-theme = "Dracula";
      };
    };

    # Sign commits
    signing = {
      key = "0x8C15553EEB22DB2A";
      signByDefault = true;
    };

    userName = "Joshua Gilman";
    userEmail = "joshuagilman@gmail.com";
  };
}
