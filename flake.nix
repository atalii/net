{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  inputs.unstable.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.home-manager-unstable.url = "github:nix-community/home-manager";
  inputs.home-manager-unstable.inputs.nixpkgs.follows = "unstable";

  outputs = { self, nixpkgs, unstable, home-manager, home-manager-unstable }: {
    nixosModules = {
      srvProxy = import ./srvProxy.nix;
      home = import ./home;
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
      };

      # Obligatory silly little guy mention... My laptop is constantly on the
      # verge of quietly perishing, but we love him anyway.
      gregor = unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common ./gregor/configuration.nix
          home-manager-unstable.nixosModules.home-manager self.nixosModules.home
        ];
      };
    };
  };
}
