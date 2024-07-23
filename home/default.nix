{ config, pkgs, ... }:

{
  home-manager.backupFileExtension = "bak";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.atalii = {
    home.stateVersion = "23.11";

    programs.home-manager.enable = true;

    programs.zsh = {
      enable = true;
      initExtra = ''
        PS1="%(?.%F{green}✓%f.%F{red}%?%f) [%~]: "

        [ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
      '';
    };
  };
}
