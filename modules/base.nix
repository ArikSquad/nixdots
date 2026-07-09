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
  i18n.defaultLocale = "fi_FI.UTF-8";

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
