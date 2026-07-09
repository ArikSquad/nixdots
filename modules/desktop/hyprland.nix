{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.uwsm.enable = true;

  services = {
    dbus.implementation = "broker";
    gnome.gnome-keyring.enable = true;
  };

  security.pam.services.greetd.enableGnomeKeyring = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    brightnessctl
    cliphist
    grim
    hyprpicker
    hyprpolkitagent
    hyprshot
    libnotify
    loupe
    networkmanagerapplet
    pavucontrol
    playerctl
    qt6.qtwayland
    slurp
    swappy
    swww
    wl-clipboard
    wlogout
  ];
}
