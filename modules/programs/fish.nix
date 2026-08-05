{ pkgs, username, ... }:
let
  nativeLibraries = with pkgs; [
    glib
    gtk3
    at-spi2-core
    pango
    harfbuzz
    cairo
    gdk-pixbuf
    webkitgtk_4_1
    libsoup_3
    openssl
  ];

  nativeLibraryClosure = pkgs.lib.closePropagation nativeLibraries;

  pkgConfigPath = pkgs.lib.concatStringsSep ":" [
    (pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" nativeLibraryClosure)
    (pkgs.lib.makeSearchPathOutput "out" "lib/pkgconfig" nativeLibraryClosure)
    (pkgs.lib.makeSearchPathOutput "dev" "share/pkgconfig" nativeLibraryClosure)
    (pkgs.lib.makeSearchPathOutput "out" "share/pkgconfig" nativeLibraryClosure)
  ];
in
{
  programs.fish = {
    enable = true;
    shellInit = ''
      set -gx PKG_CONFIG_PATH ${pkgs.lib.escapeShellArg pkgConfigPath}
    '';
  };
  users.users.${username}.shell = pkgs.fish;

  environment.shells = [ pkgs.fish ];
}
