{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

  inputs.nixos-hardware.url = "github:nixos/nixos-hardware";

  inputs.home-manager.url = "github:nix-community/home-manager/release-25.05";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.cabinet.url = "github:atalii/cabinet";
  inputs.cabinet.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      cabinet,
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      nixosModules = {
        home = import ./home;

        fonts =
          { pkgs, config, ... }:
          {
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
            ./common
            ./baumgartner/configuration.nix
            cabinet.nixosModules.cabinet

            home-manager.nixosModules.home-manager
            self.nixosModules.home.headless
          ];
        };

        # My Framework. Incomprehensible.
        "thing-in-itself" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common
            ./thing-in-itself
            nixos-hardware.nixosModules.framework-13-7040-amd
            home-manager.nixosModules.home-manager
            self.nixosModules.home.headless
            self.nixosModules.home.gui
          ];
        };

        # Sensuous manifold. Its coherency is largely disputed.
        "sensuous-manifold" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common
            ./sensuous-manifold
            home-manager.nixosModules.home-manager
            self.nixosModules.home.headless
          ];
        };

        # Gardiner (the Helsinki Hetzner VM) refers to Jerzy
        # Kosinski's /Being There/. Gardiner has no reason to be where
        # he is. Just don't worry about it.
        gardiner = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./common
            ./gardiner/configuration.nix
            home-manager.nixosModules.home-manager
            self.nixosModules.home.headless
          ];
        };

        # Obligatory silly little guy mention... My laptop is constantly on the
        # verge of quietly perishing, but we love him anyway.
        gregor = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common
            ./gregor/configuration.nix
            home-manager.nixosModules.home-manager
            self.nixosModules.home
          ];
        };
      };
    };
}
