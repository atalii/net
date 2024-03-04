{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  inputs.unstable.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, unstable }: {
    nixosModules.srvProxy = import ./srvProxy.nix;

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
        ];
      };

      # Obligatory silly little guy mention... My laptop is constantly on the
      # verge of quietly perishing, but we love him anyway.
      gregor = unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./common ./gregor/configuration.nix ];
      };
    };
  };
}
