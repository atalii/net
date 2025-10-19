{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

  inputs.nixos-hardware.url = "github:nixos/nixos-hardware";

  inputs.home-manager.url = "github:nix-community/home-manager/release-25.05";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.cabinet.url = "github:atalii/cabinet";
  inputs.cabinet.inputs.nixpkgs.follows = "nixpkgs";

  inputs.passel.url = "github:atalii/passel";
  inputs.passel.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      cabinet,
      passel,
    }:
    {
      packages.x86_64-linux.opodsync =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "opodsync";
          version = "0.4.4";

          # We use this over dontBuild so that the patch is applied.
          dontBuild = true;

          src = pkgs.fetchFromGitHub {
            owner = "kd2org";
            repo = "opodsync";
            rev = finalAttrs.version;
            hash = "sha256-e31yUa+xrtSnOgLYox/83KZSH2Dj0qxqlwKvBpro/2w=";
          };

          patches = [ ./patches/opodsync/0001-fix-put-data-files-in-DATA_ROOT.patch ];

          installPhase = ''
            runHook preInstall

            mkdir -p $out/share
            cp -rv server $out/share/opodsync

            runHook postInstall
          '';
        });

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      devShells.x86_64-linux.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            ansible
            (pkgs.writeShellScriptBin "net-update" ''
              exec ${pkgs.lib.getExe' pkgs.ansible "ansible-playbook"} \
                -i ${builtins.toString ./.}/non-nix/ansible/inventory.yaml \
                ${builtins.toString ./.}/non-nix/ansible/playbook.yaml \
                -K -u tali "$@"
            '')
          ];
        };

      nixosModules = {
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

          specialArgs = {
            inherit passel;
          };

          modules = [
            ./common
            ./baumgartner/configuration.nix
            cabinet.nixosModules.cabinet

            home-manager.nixosModules.home-manager
            self.nixosModules.home.headless

            {
              nixpkgs.overlays = [
                (self': super: {
                  opodsync = self.packages.x86_64-linux.opodsync;
                })
              ];
            }
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

        # Phenomenal information. Vegemite, &c.
        "phenomenal-information" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common
            ./phenomenal-information
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
