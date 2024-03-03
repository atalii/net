{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs }: {
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
          ./baumgartner/configuration.nix self.nixosModules.srvProxy
        ];
      };
    };
  };
}
