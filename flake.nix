{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

  inputs.nixos-hardware.url = "github:nixos/nixos-hardware";

  inputs.home-manager.url = "github:nix-community/home-manager/release-24.11";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.imhdss.url = "github:atalii/is-my-hard-disk-still-spinning";
  inputs.imhdss.inputs.nixpkgs.follows = "nixpkgs";

  inputs.cabinet.url = "github:atalii/cabinet";
  inputs.cabinet.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    { self
    , nixpkgs
    , nixos-hardware
    , home-manager
    , imhdss
    , cabinet
    }: {

      nixosModules = {
        srvProxy = import ./srvProxy.nix;
        home = import ./home;
        home2 = import ./home.2;

        fonts = { pkgs, config, ... }: {
          fonts.packages = [ self.packages.x86_64-linux.berkeley-mono ];
        };
      };

      # Hostnames refer to characters from stuffy pretentious literature that
      # feel somehow appropriate.
      nixosConfigurations = {
        # Define the big basement server. It's a bunch of five year old
        # components, all of whom are mourning the GPU that was so cruelly ripped
        # away from them. (Named for Baumgartner in Paul Auster's novel
        # (novella?) of the same name.)
        baumgartner = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common ./baumgartner/configuration.nix self.nixosModules.srvProxy
            home-manager.nixosModules.home-manager self.nixosModules.home
            cabinet.nixosModules.cabinet
          ];

          specialArgs = { inherit imhdss; };
        };

        # My Framework. Incomprehensible.
        "thing-in-itself" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./thing-in-itself nixos-hardware.nixosModules.framework-13-7040-amd
            home-manager.nixosModules.home-manager self.nixosModules.home2
          ];
        };

        # Gardiner (the Helsinki Hetzner VM) refers to Jerzy
        # Kosinski's /Being There/. Gardiner has no reason to be where
        # he is. Just don't worry about it.
        gardiner = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./common ./gardiner/configuration.nix ];
        };

        # Obligatory silly little guy mention... My laptop is constantly on the
        # verge of quietly perishing, but we love him anyway.
        gregor = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common ./gregor/configuration.nix
            home-manager.nixosModules.home-manager self.nixosModules.home
          ];
        };
      };

      packages.x86_64-linux =
        let pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in pkgs.callPackage ./pkgs {};
    };
}
