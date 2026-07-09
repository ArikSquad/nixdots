{
  appimageTools,
  fetchurl,
  lib,
}:

appimageTools.wrapType2 rec {
  pname = "t3code";
  version = "0.0.28";

  src = fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha256-+mBp+wPrJRV/HpaimQHcqBuwqZcPWTbKJVNCVW7ELgo=";
  };

  meta = {
    description = "T3 Code desktop app";
    homepage = "https://github.com/pingdotgg/t3code";
    license = lib.licenses.mit;
    mainProgram = "t3code";
    platforms = ["x86_64-linux"];
  };
}
