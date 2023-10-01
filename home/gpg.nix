{...}: {
  programs.gpg = {
    enable = true;
    publicKeys = [{source = ./files/gpg;}];
  };
}
