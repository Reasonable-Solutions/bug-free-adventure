{ mkDerivation, aeson, base, servant-server, servant-swagger
, stdenv, swagger2, text, wai-cors, wai-extra, warp
}:
mkDerivation {
  pname = "BarnehageService";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base servant-server servant-swagger swagger2 text wai-cors
    wai-extra warp
  ];
  license = stdenv.lib.licenses.bsd3;
}
