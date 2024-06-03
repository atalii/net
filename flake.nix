{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

  inputs.home-manager.url = "github:nix-community/home-manager/release-24.05";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.imhdss.url = "github:atalii/is-my-hard-disk-still-spinning";
  inputs.imhdss.inputs.nixpkgs.follows = "nixpkgs";

  inputs.fenix = {
    url = "github:nix-community/fenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , imhdss
    , fenix
    }: {
      nixosModules = {
        srvProxy = import ./srvProxy.nix;
        home = import ./home;
        fenix = { pkgs, config, ... }: {
          environment.systemPackages = [ fenix.packages.x86_64-linux.stable.toolchain ];
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
          ];

          specialArgs = { inherit imhdss; };
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

        # Sartre's favorite lesbian.
        inez = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common ./inez/configuration.nix
            home-manager.nixosModules.home-manager
            self.nixosModules.home self.nixosModules.fenix
          ];
        };
      };
    };
}
