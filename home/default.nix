{ config, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.atalii = {
    home.stateVersion = "23.11";

    programs.home-manager.enable = true;

    dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

    home.packages = with pkgs; [ dconf brightnessctl ];
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome.gnome-themes-extra;
      };
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

    programs.eww.enable = true;
    programs.eww.configDir = ./eww;

    programs.kitty = {
      enable = true;
      settings = {
        font_family = "Input Mono";

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

    programs.nushell = {
      enable = true;

      extraConfig = ''
        $env.config = {
          show_banner: false
        }
      '';

      extraEnv = ''
        # just an empty env file
      '';
    };

    xdg.configFile."wayfire.ini".text = ''
      [core]
      vheight = 2
      vwidth = 2
      preferred_decoration_mode = client

      plugins = autostart animate alpha resize command scale expo move decoration extra-gestures wobbly vswitch

      [output:eDP-1]
      scale = 1.25
      
      [blur]
      blur.method = kawase

      [command]
      binding_terminal = <super> KEY_L
      command_terminal = kitty

      binding_ff = <super> KEY_R
      command_ff = firefox

      binding_tb = <super> KEY_C
      command_tb = thunderbird

      binding_cr = <super> KEY_G
      command_cr = chromium

      [expo]
      toggle = <super> KEY_A | pinch in 4
      offset = 128
      duration = 100

      [scale]
      toggle_all = <super> KEY_H
      duration = 100

      [decoration]
      border_size = 0
      title_height = 24

      [wobbly]
      spring_k = 512.0
      friction = 4.0

      font = InputMono
      active_color = \#2d353bff
      inactive_color = \#2d353bff

      [extra-gestures]
      move_fingers = 2
      move_delay = 300

      [vswitch]
      binding_down = swipe up 3
      binding_up = swipe down 3
      binding_left = swipe right 3
      binding_right = swipe left 3

      [autostart]
      background = wf-background
      panel = eww daemon && sleep 1 && eww open bar

      autostart_wf_shell = false
    '';
    
    xdg.configFile."wf-shell.ini".text = ''
      [background]
      image = ${./res/bg.jpg}
      preserve_aspect = 1
    '';
  };
}
