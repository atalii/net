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
    };

  programs.fish.enable = true;
  users.users.tali.shell = pkgs.fish;
}
