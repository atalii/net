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
	  catppuccin-nvim
	  coc-nvim
	  coc-svelte
	  nvim-lspconfig
	  vim-svelte
	];

	extraLuaConfig = ''
	  vim.cmd [[colorscheme catppuccin-latte]]

	  local lspconfig = require('lspconfig')
	  lspconfig.clangd.setup{}
	  lspconfig.gopls.setup{}
	  lspconfig.hls.setup{}
	  lspconfig.svelte.setup{}
	  lspconfig.tinymist.setup{}

	  lspconfig.nil_ls.setup {
	    settings = {
	      nix = {
	        flake = {
		  autoArchive = true,
		},
	      },
	    },
	  }

	  vim.api.nvim_create_autocmd('LspAttach', {
	    callback = function(ev)
	      vim.opt.number = true
	      vim.api.nvim_create_autocmd("BufWritePre", {
	        callback = function(ev)
		  vim.lsp.buf.format {bufnr = ev.buf}
		end
	      })
	    end,
	  })
	'';
      };

      programs.fish.enable = true;
      programs.zoxide.enable = true;

      home.sessionVariables = rec {
        EDITOR = VISUAL;
        VISUAL = "nvim";
      };
    };

  programs.starship = {
    enable = true;

    settings = {
      format = "$directory $fill $git_branch$hostname\n$character";
      fill.symbol = " ";

      character = {
        success_symbol = "[\\[λ\\]](bold green)";
        error_symbol = "[\\[λ\\]](bold red)";
      };

      directory.fish_style_pwd_dir_length = 1;
      git_branch.format = "[$symbol$branch(:$remote_branch)]($style) ";
      hostname.format = "[@$hostname](bold dimmed yellow)";
    };
  };

  users.users.tali = {
    shell = pkgs.fish;
    packages = with pkgs; [
      dnsutils

      nil

      tinymist typst

      curl openssl

      tree file
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  programs.command-not-found.enable = false;

  users.users.tali = {
    isNormalUser = true;
    description = "Tali Auster";
    extraGroups = [ "networkmanager" "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlsdZRN8i12v5Uv2ZZtGqxqbf8T/n0H6U/UagIPUZy5 tali@thing-in-itself"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRTkQVQRBU7fBCVPRFjBKQmUyk6sl8G1m3UERtOVmF4 tali@baumgartner"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGE91J/xuWmLxKrYNUy0PywvOla5gQdYu3JsN9cHI1YQ tali@gardiner"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBJ6H8jQFrrQ8DT1IAdqitLkpZFlzUkjhNAh+spzIWC3 tali@sensuous-manifold"
    ];
  };
}
