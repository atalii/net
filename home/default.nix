{ config, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.atalii = {
    home.stateVersion = "23.11";

    programs.home-manager.enable = true;
    
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
    };
  };
}
