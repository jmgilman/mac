{...}: {
  programs.starship = {
    enable = true;
    settings = {
      battery = {
        disabled = true;
      };
      directory = {
        style = "green";
        truncate_to_repo = false;
      };
      hostname = {
        format = "[$hostname]($style) ";
        style = "bright-black";
      };
      nix_shell = {
        format = "via [$symbol$name]($style) ";
      };
      username = {
        format = "[$user@]($style)";
        style_user = "bright-black";
      };
    };
  };
}
