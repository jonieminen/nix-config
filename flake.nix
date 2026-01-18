{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    homestakeros-base.url = "github:ponkila/homestakeros?dir=nixosModules/base";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, ... }@inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } rec {

    systems = [ "x86_64-linux" ];
    imports = [ ];
    perSystem = { pkgs, config, system, inputs', ... }: {

      # Begins flake schema for all supported `systems`

      # nix develop
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          cowsay
        ];
      };

      # nix build .#prose
      packages = {
        "prose" = flake.nixosConfigurations.prose.config.system.build.kexecTree;
      };
    };

    flake =
      let
        inherit (self) outputs;

        prose = {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixosConfigurations/prose
            ./nix-settings.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.homestakeros-base.nixosModules.kexecTree
          ];
        };

      in
      {
        # sudo nixos-rebuild test --flake .#prose
        nixosConfigurations = {
          "prose" = inputs.nixpkgs.lib.nixosSystem prose;
        };
      };
  };
}
