# nix-template
High quality and modern nix flakes for bootstrapping projects.

Every flake includes the following
- development shell
- [direnv](https://direnv.net/) integration
- init app
  - When creating a new project, use this to initialize the project
- nix shell integration
- run app
- GitHub continuous integration

The best way to see how to use one of these templates is with an example
```sh
nix flake init -t github:mbund/nix-template#python.poetry2nix
nix run .#init
```
or
```sh
nix flake new -t github:mbund/nix-template#python.poetry2nix ./my-poetry-project
cd my-poetry-project
nix run .#init
```

- [ ] python
  - [ ] native
  - [ ] poetry2nix
  - [ ] pypi
- [ ] haskell
  - [ ] native
  - [ ] cabal2nix
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
