{
  description = "python-poetry2nix template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    poetry2nix.url = "github:nix-community/poetry2nix";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = { self, nixpkgs, poetry2nix, flake-utils, ... }:
    flake-utils.lib.eachSystem (with flake-utils.lib.system; [
      x86_64-linux

    ]) (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          poetry2nix.overlay
        ];
      };

      poetryEnv = pkgs.poetry2nix.mkPoetryEnv {
        python = pkgs.python3;
        projectDir = ./.;
      };

      packageName = throw "package name required!";

    in {

      devShells.init = pkgs.mkShell {
        packages = with pkgs; [
          poetry
        ];
      };

      devShells.dev = pkgs.mkShell {
        buildInputs = with pkgs; [
        ];

        inputsFrom = [
          self.devShells.${system}.init
          poetryEnv.env
        ];

        shellHook = ''
          [ $STARSHIP_SHELL ] && exec $STARSHIP_SHELL
        '';

        CURRENT_PROJECT = packageName;
      };

      devShell = self.devShells.${system}.dev;

    });

}
