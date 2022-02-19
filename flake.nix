{
  description = "Templates";

  outputs = { self }: {
    
    templates.haskell-cabal2nix = {
      path = ./haskell-cabal2nix;
      description = "haskell cabal2nix init project";
    };

    templates.rust-crate2nix = {
      path = ./rust-crate2nix;
      description = "rust crate2nix init project";
    };

    templates.nodejs = {
      path = ./nodejs;
      description = "nodejs node2nix init project";
    };

    templates.python-poetry2nix = {
      path = ./python-poetry2nix;
      description = "python poetry2nix init project";
    };

  };
}
