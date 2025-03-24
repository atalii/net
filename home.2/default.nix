{ config, pkgs, ... }:

{
  home-manager.backupFileExtension = "bak";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.tali =
    { config, pkgs, ... }: {
      home.stateVersion = "23.11";
      programs.home-manager.enable = true;
  
      xdg.userDirs =
        let inHome = path: "${config.home.homeDirectory}/${path}";
        in {
          enable = true;
          createDirectories = false;
  
          desktop = inHome "dsk";
          documents = inHome "doc";
          download = inHome "dwn";
          music = inHome "mus";
          pictures = inHome "pic";
          publicShare = inHome "pub";
          videos = inHome "vid";
        };
  
      programs.neovim = {
        enable = true;
	defaultEditor = true;
	viAlias = true; # :)

	plugins = with pkgs.vimPlugins; [
	  nvim-lspconfig
	  catppuccin-nvim
	];

	extraLuaConfig = ''
	  vim.cmd [[colorscheme catppuccin-latte]]
	'';
      };
  
      programs.ghostty = {
        enable = true;
        settings = {
          theme = "catppuccin-latte";
	  font-family = "Berkeley Mono";
        };
      };

      systemd.user.sessionVariables = rec {
        EDITOR = VISUAL;
        VISUAL = "nvim";
      };
    };

  programs.starship.enable = true;
  users.users.tali.shell = pkgs.fish;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };


  users.users.tali.packages = with pkgs; [
    signal-desktop thunderbird
  ];
}
