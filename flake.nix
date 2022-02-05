{
  description = "Templates";

  outputs = { self }: {
    
    templates.haskell-cabal2nix = {
      path = ./haskell/cabal2nix;
      description = "cabal2nix init project";
    };

  };
}
