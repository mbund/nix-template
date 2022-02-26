{
  description = "rust-cargo2nix template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    cargo2nix.url = "github:cargo2nix/cargo2nix/master";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = { self, nixpkgs, cargo2nix, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachSystem
      (with flake-utils.lib.system; [
        x86_64-linux

      ])
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (import "${cargo2nix}/overlay")
              rust-overlay.overlay
            ];
          };

          rustPkgs = pkgs.rustBuilder.makePackageSet' {
            rustChannel = "latest";
            packageFun = import ./Cargo.nix;
            packageOverrides = pkgs: pkgs.rustBuilder.overrides.all ++ [
              (pkgs.rustBuilder.rustLib.makeOverride {
                name = packageName;
                overrideAttrs = attrs: {
                  # Dependency overrides go here
                };
              })
            ];
          };

          # Must match package name in Cargo.toml
          packageName = throw "package name required!";

        in
        rec {
          packages.${packageName} = (rustPkgs.workspace.${packageName} { }).bin;

          # WHEN YOU ADD ANY PACKAGE
          # nix develop .#init
          # cargo generate-lockfile
          # cargo2nix -f
          devShells.init = pkgs.mkShell {
            buildInputs = with pkgs; [
              cargo2nix.defaultPackage.${system}
              cargo
              rustc
            ];
          };

          devShells.dev = pkgs.mkShell rec {
            buildInputs = with pkgs; [
              rust-analyzer
              rustfmt
            ];

            LD_LIBRARY_PATH = "${nixpkgs.lib.makeLibraryPath buildInputs}";

            inputsFrom = [
              self.devShells.${system}.init
              self.packages.${system}.${packageName}
            ];

            shellHook = ''
              [ $STARSHIP_SHELL ] && exec $STARSHIP_SHELL
            '';

            CURRENT_PROJECT = packageName;
          };

          defaultPackage = self.packages.${system}.${packageName};
          devShell = self.devShells.${system}.dev;

        });

}




