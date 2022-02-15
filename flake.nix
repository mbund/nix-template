{
  description = "Templates";

  outputs = { self }: {
    
    templates.haskell-cabal2nix = {
      path = ./haskell-cabal2nix;
      description = "cabal2nix init project";
    };

    templates.rust-crate2nix = {
      path = ./rust-crate2nix;
      description = "crate2nix init project";
    };

  };
}
