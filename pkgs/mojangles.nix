{
  fetchurl,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "mojangles";
  version = "1";

  src = fetchurl {
    url = "https://git.minecraftlegacy.com/backups/4jcraft/raw/commit/21430e1758a38f6336a3c000c206fbbeaba8cb4c/Minecraft.Assets/font/Mojangles.ttf";
    hash = "sha256-PUzfJ1IHXSjG6/C6RKYRV+xus4+NsOvcMgWuwFZ2C+U=";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 "$src" "$out/share/fonts/truetype/Mojangles.ttf"
  '';

  meta = {
    description = "The Minecraft Mojangles typeface";
    homepage = "https://git.minecraftlegacy.com/backups/4jcraft/src/commit/21430e1758a38f6336a3c000c206fbbeaba8cb4c/Minecraft.Assets/font";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.all;
  };
}
