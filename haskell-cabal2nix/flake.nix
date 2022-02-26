{
  description = "haskell-cabal2nix template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem
      (with flake-utils.lib.system; [
        x86_64-linux

      ])
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };

          packageName = throw "package name required!";

        in
        {

          packages.${packageName} = pkgs.haskellPackages.callCabal2nix packageName self {
            # Dependency overrides go here
          };

          devShells.init = pkgs.mkShell {
            packages = with pkgs; [
              cabal-install
              ghc
            ];
          };

          devShells.dev = pkgs.mkShell {
            buildInputs = with pkgs; [
              haskellPackages.haskell-language-server
              ghcid
            ];

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

