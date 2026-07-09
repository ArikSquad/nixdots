{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --user-menu --asterisks --cmd 'uwsm start hyprland-uwsm.desktop'";
      };
    };
  };

  environment.systemPackages = [pkgs.tuigreet];
}
