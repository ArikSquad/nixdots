{ pkgs, ... }:
let
  pixel-sakura = pkgs.stdenvNoCC.mkDerivation {
    pname = "sddm-theme";
    version = "1.0";
    src = ../../config/sddm/pixel-sakura;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/sddm/themes/theme
      cp -r . $out/share/sddm/themes/theme
      runHook postInstall
    '';
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "theme";
    extraPackages = with pkgs.qt6; [
      qtmultimedia
      qtsvg
      qtvirtualkeyboard
    ];
  };

  environment.systemPackages = [ pixel-sakura ];
}
