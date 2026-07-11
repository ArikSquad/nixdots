{pkgs, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  boot = {
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.systemd.enable = true;
  };

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.xserver.xkb = {
    layout = "fi";
    variant = "";
  };
   # lowkey i dont like this here?
  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
    enableAuth = false;
    bind_ip = "0.0.0.0";
  };
  # lowkey also annoying to have this always running in the bg
  services.redis.servers.myredis = {
    enable = true;
    port = 6379;
  };

  console.keyMap = "fi";

  services = {
    dbus.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    power-profiles-daemon.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  environment.systemPackages = with pkgs; [
    age
    alejandra
    btop
    polkit_gnome
    curl
    fastfetch
    fd
    git
    jq
    nh
    nixd
    pciutils
    ripgrep
    sbctl
    unzip
    usbutils
    wget
  ];
}
