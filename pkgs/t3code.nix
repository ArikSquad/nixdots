{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
  symlinkJoin,
}:

let
  pname = "t3code";
  version = "0.0.33-nightly.20260810.1055";

  src = fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha256-3aHMA61m1h8cJTFIcVUSCQTXk0Ags55JVDA5Rp7lnlU=";
  };

  app = appimageTools.wrapType2 {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "T3 Code";
    genericName = "Code Editor";
    comment = "T3 Code desktop app";
    exec = "${pname} %U";
    icon = pname;
    categories = [
      "Development"
      "IDE"
    ];
    startupNotify = true;
  };
in
symlinkJoin {
  inherit pname version;
  paths = [
    app
    desktopItem
  ];
  postBuild = ''
    install -Dm644 ${./t3code.png} \
      $out/share/icons/hicolor/512x512/apps/t3code.png
  '';

  meta = with lib; {
    description = "T3 Code desktop app";
    homepage = "https://github.com/pingdotgg/t3code";
    license = licenses.mit;
    mainProgram = "t3code";
    platforms = [ "x86_64-linux" ];
  };
}
