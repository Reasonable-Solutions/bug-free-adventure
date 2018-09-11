{ mkDerivation, aeson, base, servant-server, servant-swagger
, sqlite-simple, stdenv, swagger2, text, transformers, wai-cors
, wai-extra, warp
}:
mkDerivation {
  pname = "BarnehageService";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base servant-server servant-swagger sqlite-simple swagger2
    text transformers wai-cors wai-extra warp
  ];
  license = stdenv.lib.licenses.bsd3;
}
