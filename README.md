# nix-template
High quality and modern nix flake templates for bootstrapping projects.

Every flake includes the following
- development shell
- init shell
  - When creating a new project, use this to initialize the project
- nix shell integration
- GitHub continuous integration
- backwards compatible with non-flakey nix

The best way to see how to use one of these templates is with an example
```sh
nix flake init -t github:mbund/nix-template#haskell-cabal2nix
# edit `flake.nix` to set package name
nix develop .#init -c $SHELL
# use `cabal init` as normal...
```
or
```sh
nix flake new -t github:mbund/nix-template#haskell-cabal2nix ./my-haskell-project
cd my-haskell-project
# edit `flake.nix` to set package name
nix develop .#init -c $SHELL
# use `cabal init` as normal...
```

## Support
- [ ] python
  - [ ] native
  - [ ] poetry2nix
  - [ ] pypi
- [ ] haskell
  - [ ] native
  - [x] cabal2nix
  - [ ] stack
- [ ] rust
  - [ ] cargo2nix
- [ ] c
  - [ ] make
  - [ ] cmake
- [ ] cpp
  - [ ] cmake
- [ ] bash
- [ ] go
- [ ] nodejs
  - [ ] node2nix
    - [ ] react
    - [ ] server
- [ ] website

## Resources
Some great resources that I need to go back to
- https://myme.no/posts/2022-01-16-nixos-the-ultimate-dev-environment.html
- https://github.com/serokell/templates
