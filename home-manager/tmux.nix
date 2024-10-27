{ pkgs, ... }:
let
  bg = "default";
  fg = "default";
  bg2 = "brightblack";
  fg2 = "white";
  color = c: "#{@${c}}";

  indicator =
    let
      accent = color "indicator_color";
      content = "  ";
    in
    "#[reverse,fg=${accent}]#{?client_prefix,${content},}";

  current_window =
    let
      accent = color "main_accent";
      index = "#[reverse,fg=${accent},bg=${fg}] #I ";
      name = "#[fg=${bg2},bg=${fg2}] #W ";
    in
    # flags = "#{?window_flags,#{window_flags}, }";
    "${index}${name}";

  window_status =
    let
      accent = color "window_color";
      index = "#[reverse,fg=${accent},bg=${fg}] #I ";
      name = "#[fg=${bg2},bg=${fg2}] #W ";
    in
    # flags = "#{?window_flags,#{window_flags}, }";
    "${index}${name}";

  time =
    let
      accent = color "main_accent";
      format = "%H:%M";
      icon = pkgs.writeShellScript "icon" ''
        hour=$(date +%H)
        if   [ "$hour" == "00" ] || [ "$hour" == "12" ]; then printf "󱑖"
        elif [ "$hour" == "01" ] || [ "$hour" == "13" ]; then printf "󱑋"
        elif [ "$hour" == "02" ] || [ "$hour" == "14" ]; then printf "󱑌"
        elif [ "$hour" == "03" ] || [ "$hour" == "15" ]; then printf "󱑍"
        elif [ "$hour" == "04" ] || [ "$hour" == "16" ]; then printf "󱑎"
        elif [ "$hour" == "05" ] || [ "$hour" == "17" ]; then printf "󱑏"
        elif [ "$hour" == "06" ] || [ "$hour" == "18" ]; then printf "󱑐"
        elif [ "$hour" == "07" ] || [ "$hour" == "19" ]; then printf "󱑑"
        elif [ "$hour" == "08" ] || [ "$hour" == "20" ]; then printf "󱑒"
        elif [ "$hour" == "09" ] || [ "$hour" == "21" ]; then printf "󱑓"
        elif [ "$hour" == "10" ] || [ "$hour" == "22" ]; then printf "󱑔"
        elif [ "$hour" == "11" ] || [ "$hour" == "23" ]; then printf "󱑕"
        fi
      '';
    in
    "#[reverse,fg=${accent}] ${format} #(${icon}) ";

  pwd =
    let
      accent = color "main_accent";
      icon = "#[fg=${accent}] ";
      format = "#[fg=${fg}]#{b:pane_current_path}";
    in
    "${icon}${format}";

  git =
    let
      icon = pkgs.writeShellScript "branch" ''
        git -C "$1" branch && echo " "
      '';
      branch = pkgs.writeShellScript "branch" ''
        git -C "$1" rev-parse --abbrev-ref HEAD
      '';
    in
    "#[fg=magenta]#(${icon} #{pane_current_path})#(${branch} #{pane_current_path})";

  separator = "#[fg=${fg}]|";
in
{
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
    ];
    prefix = "C-Space";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "emacs";
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      bind-key b set-option status
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      set-option -g default-terminal "screen-256color"
      set-option -g status-right-length 100
      set-option -g @indicator_color "yellow"
      set-option -g @window_color "magenta"
      set-option -g @main_accent "blue"
      set-option -g pane-active-border fg=black
      set-option -g pane-border-style fg=black
      set-option -g status-style "bg=${bg} fg=${fg}"
      set-option -g status-left "${indicator}"
      set-option -g status-right "${git} ${pwd} ${separator} ${time}"
      set-option -g window-status-current-format "${current_window}"
      set-option -g window-status-format "${window_status}"
      set-option -g window-status-separator ""
    '';
  };
}
