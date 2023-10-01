{...}: {
  programs.tmux = {
    enable = true;

    prefix = "C-a";
    baseIndex = 1;
    terminal = "screen-256color";

    extraConfig = ''
      bind m set-window-option main-pane-height 60\; select-layout main-horizontal
    '';

    tmuxp.enable = true;
  };
}
