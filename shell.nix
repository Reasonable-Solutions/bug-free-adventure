with (import <nixpkgs> {});
with haskell.packages.ghc822;
(mkDerivation {
  pname = "validation-course";
  version = "0.1.0.0";
  src = ./.;
  buildDepends = [ base validation zlib];
  isExecutable = true;
  buildTools = [ cabal-install cabal2nix ghcid];
  license = stdenv.lib.licenses.gpl3;
}).env
