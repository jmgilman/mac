{...}: {
  programs.gpg = {
    enable = true;
    publicKeys = [{source = ../files/gpg;}];
  };
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3600;
    enableExtraSocket = true;
    pinentryFlavor = "curses";
  };
}
