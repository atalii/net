{ config, pkgs, ... }:

{
  home-manager.backupFileExtension = "bak";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.atalii = {
    home.stateVersion = "23.11";

    programs.home-manager.enable = true;

    dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

    home.packages = with pkgs; [ dconf ];

    programs.zsh = {
      enable = true;
      initExtra = ''
        PS1="%(?.%F{green}✓%f.%F{red}%?%f) [%~]: "

        [ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
      '';
    };

    programs.helix = {
      enable = true;
      defaultEditor = true;

      settings = {
        theme = "everforest_dark";

        keys.normal = {
          h = "move_prev_word_start";
          t = "move_next_word_start";
          n = "move_visual_line_up";
          s = "move_visual_line_down";

          C-h = "move_char_left";
          C-t = "move_char_right";

          r = "goto_line_start";
          l = "goto_line_end";

          g = "replace";
        };
      };

      languages = {
        language = [{
          name = "cpp";
          indent.tab-width = 8;
          indent.unit = "\t";
        }];
      };
    };

    programs.kitty = {
      enable = true;
      settings = {
        font_family = "Berkeley Mono";
        font_size = "12";

        # This bit (everforest dark medium) is fully stolen from the theme kitten.
        foreground = "#d3c6aa";
        background = "#2d353b";
        selection_foreground = "#9da9a0";
        selection_background = "#505a60";
        cursor               = "#d3c6aa";
        cursor_text_color    = "#343f44";

        url_color = "#7fbbb3";

        active_border_color   = "#a7c080";
        inactive_border_color = "#56635f";
        bell_border_color     = "#e69875";
        visual_bell_color     = "none";

        active_tab_background   = "#2d353b";
        active_tab_foreground   = "#d3c6aa";
        inactive_tab_background = "#3d484d";
        inactive_tab_foreground = "#9da9a0";
        tab_bar_background      = "#343f44";
        top_bar_margin_color    = "none";

        mark1_foreground = "#2d353b";
        mark1_background = "#7fbbb3";
        mark2_foreground = "#2d353b";
        mark2_background = "#d3c6aa";
        mark3_foreground = "#2d353b";
        mark3_background = "#d699b6";

        color0 = "#343f44"; color8  = "#868d80"; # black
        color1 = "#e67e80"; color9  = "#e67e80"; # red
        color2 = "#a7c080"; color10 = "#a7c080"; # green
        color3 = "#dbbc7f"; color11 = "#dbbc7f"; # yellow
        color4 = "#7fbbb3"; color12 = "#7fbbb3"; # blue
        color5 = "#d699b6"; color13 = "#d699b6"; # magenta
        color6 = "#83c092"; color14 = "#83c092"; # cyan
        color7 = "#859289"; color15 = "#9da9a0"; # white
      };
    };
  };
}
