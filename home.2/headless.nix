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

	  local lspconfig = require('lspconfig')
	  lspconfig.hls.setup{}
	'';
      };

      programs.fish.enable = true;

      home.sessionVariables = rec {
        EDITOR = VISUAL;
        VISUAL = "nvim";
      };
    };

  programs.starship.enable = true;

  users.users.tali = {
    shell = pkgs.fish;
    packages = with pkgs; [
      haskell-language-server ghc cabal-install

      curl openssl
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  users.users.tali = {
    isNormalUser = true;
    description = "Tali Auster";
    extraGroups = [ "networkmanager" "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlsdZRN8i12v5Uv2ZZtGqxqbf8T/n0H6U/UagIPUZy5 tali@thing-in-itself"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRTkQVQRBU7fBCVPRFjBKQmUyk6sl8G1m3UERtOVmF4 tali@baumgartner"
    ];
  };
}
