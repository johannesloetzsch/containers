{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    extra-container.url = "github:erikarvstedt/extra-container";
  };

  outputs = { self, nixpkgs, extra-container, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    lib = pkgs.lib;

    stateVersion = "23.11";

    nixosConfigurationsFromContainerConfigs = containerName: containerConfig:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            boot.isContainer = true;
            system = { inherit stateVersion; };
          }
          containerConfig.config
        ];
      };

    buildContainerFromContainerConfigs = containerName: containerConfig:
      lib.attrsets.nameValuePair
        ("buildContainer_" + containerName)
        (extra-container.lib.buildContainers {
          inherit system;
          inherit nixpkgs;
          config.containers."${containerName}" = containerConfig;
        });

    buildContainer_ = lib.attrsets.mapAttrs' buildContainerFromContainerConfigs (import ./nix/containers.nix).containers;

  in rec {
    
    nixosConfigurations = builtins.mapAttrs nixosConfigurationsFromContainerConfigs (import ./nix/containers.nix).containers;

    packages."${system}" =

      buildContainer_ //

    rec {

      buildContainers = extra-container.lib.buildContainers {
        inherit system;
        inherit nixpkgs;
        config = (import ./nix/containers.nix);
      };

      default = buildContainers;

    };
  };
}
