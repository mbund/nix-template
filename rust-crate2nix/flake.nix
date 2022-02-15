{
  description = "Rust template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    crate2nix = { url = "github:kolloch/crate2nix"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = { self, nixpkgs, crate2nix, flake-utils, ... }:
    flake-utils.lib.eachSystem (with flake-utils.lib.system; [
      x86_64-linux

    ]) (system: let
      pkgs = import nixpkgs {
        inherit system;
      };

      inherit (import "${crate2nix}/tools.nix" { inherit pkgs; }) generatedCargoNix;

      packageName = throw "package name required!";

      project = import (generatedCargoNix {
        name = packageName;
        src = ./.;
      }) {
        inherit pkgs;
        defaultCrateOverrides = pkgs.defaultCrateOverrides // {
          # Dependency overrides go here
        };
      };

    in {

      packages.${packageName} = project.rootCrate.build;

      devShells.init = pkgs.mkShell {
        packages = with pkgs; [
          cargo
        ];
      };

      devShells.dev = pkgs.mkShell {
        buildInputs = with pkgs; [
          rust-analyzer
          clippy
        ];

        inputsFrom = [
          self.devShells.${system}.init
          self.packages.${system}.${packageName}
        ];

        CURRENT_PROJECT = nixpkgs.lib.escapeShellArg packageName;
      };

      defaultPackage = self.packages.${system}.${packageName};
      devShell = self.devShells.${system}.dev;

    });

}
