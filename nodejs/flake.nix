{
  description = "nodejs-node2nix template";

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

          generatedNodeJSNix = { name, src }: pkgs.stdenv.mkDerivation {
            name = "${name}-node2nix";

            inherit src;
            buildInputs = with pkgs; [ nodePackages.node2nix ];
            preferLocalBuild = true;
            phases = [ "unpackPhase" "buildPhase" ];

            buildPhase = ''
              set -e

              mkdir -p $out
              cd $out

              set -x

              node2nix \
                --nodejs-14 \
                --development \
                --input ${src}/package.json \
                --lock ${src}/package-lock.json \
            '';
          };

          generated = import
            (generatedNodeJSNix {
              name = packageName;
              src = ./.;
            })
            {
              nodejs = pkgs.nodejs-14_x;
              inherit pkgs;
            };

          packageName = throw "package name required!";

        in
        {

          packages.${packageName} = pkgs.stdenv.mkDerivation {
            name = packageName;
            src = ./.;
            buildInputs = with pkgs; [ nodejs-14_x ];

            buildPhase = ''
              ln -s ${generated.nodeDependencies}/lib/node_modules ./node_modules
              export PATH="${generated.nodeDependencies}/bin:$PATH"

              # RUN BUILD COMMANDS
              npm run build
            '';
            installPhase = ''
              # COPY THE BUILT PROJECT INTO $out
              mkdir -p $out
              # cp -r dist $out/
            '';
          };

          devShells.init = pkgs.mkShell {
            packages = with pkgs; [
              nodePackages.npm
            ];
          };

          devShells.dev = pkgs.mkShell {
            buildInputs = with pkgs; [
            ];

            inputsFrom = [
              self.devShells.${system}.init
              self.packages.${system}.${packageName}
              generated.shell
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

