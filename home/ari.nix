{
  config,
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
    packages = with pkgs; [
      bat
      eza
      fzf
      gitui
      lazygit
      nerd-fonts.caskaydia-cove
      ripgrep
      starship
      tree
      zoxide
      ghostty
      xdg-terminal-exec
      # desktop apps, move away from here tbh or idk does it even matter?
      nodejs_26
      bun
      vesktop
      kdePackages.dolphin
      jetbrains-toolbox
      prismlauncher
      steam
      t3code
    ];
    sessionVariables = {
      TERMINAL = "ghostty";
    };
  };

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixdots/config/nvim";
      recursive = false;
    };
    "xdg-terminals.list".text = ''
      com.mitchellh.ghostty.desktop
    '';
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.whitesur-cursors;
    name = "WhiteSur-cursors";
    size = 24;

    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };

  programs.caelestia = {
    enable = true;
    cli.enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    settings = {
      general.apps.explorer = [
        "dolphin"
      ];
      general.apps.terminal = [
        "ghostty"
      ];
      appearance.transparency.enabled = true;
      bar.status.showBattery = false;
      paths.wallpaperDir = "${config.home.homeDirectory}/Pictures/Wallpapers";
    };
    cli.settings.theme.enableGtk = true;
  };

  #wayland.windowManager.hyprland = {
  #  enable = true;
  #  systemd.enable = false;
  #  settings = {
  #    "$mod" = "SUPER";
  #    monitor = ",preferred,auto,1";
  #    exec-once = [
  #      "uwsm finalize"
  #      "swww-daemon"
  #      "wl-paste --type text --watch cliphist store"
  #      "wl-paste --type image --watch cliphist store"
  #    ];
  #    input = {
  #      kb_layout = "fi";
  #      follow_mouse = 1;
  #      touchpad.natural_scroll = true;
  #    };
  #    general = {
  #      gaps_in = 4;
  #       gaps_out = 8;
  #       border_size = 2;
  #      layout = "dwindle";
  #    };
  #    decoration = {
  #      rounding = 8;
  #      blur = {
  #        enabled = true;
  #        size = 4;
  #        passes = 2;
  #      };
  #    };
  #    animations.enabled = true;
  #    bind = [
  #      "$mod, Return, exec, foot"
  #      "$mod, B, exec, helium"
  #      "$mod, D, exec, caelestia shell drawers toggle launcher"
  #      "$mod, Q, killactive"
  #      "$mod SHIFT, E, exec, wlogout"
  #      "$mod, F, fullscreen"
  #    ];
  #  };
  #};

  # we trust in caelestia
  #programs.foot = {
  #  enable = true;
  #  settings = {
  #    main = {
  #      font = "CaskaydiaCove Nerd Font:size=11";
  #      pad = "8x8";
  #    };
  #  };
  #};

  # we trust in caelestia
  #programs.fish = {
  #  enable = true;
  #  interactiveShellInit = ''
  #    set fish_greeting
  #    zoxide init fish | source
  #    starship init fish | source
  #  '';
  #  shellAliases = {
  #    ls = "eza --icons=auto --group-directories-first";
  #    ll = "eza -lah --icons=auto --group-directories-first";
  #    rebuild = "sudo nixos-rebuild switch --flake ~/nixdots#nixbox";
  #  };
  #};

  programs.git = {
    enable = true;
    package = pkgs.git.override {withLibsecret = true;};
    userName = "ArikSquad";
    userEmail = "75741608+ArikSquad@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      #pull. = true;
      push.autoSetupRemote = true;
      credential.helper = "libsecret";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    sideloadInitLua = true;
    extraPackages = with pkgs; [
      lua-language-server
      nil
      nixd
      bash-language-server
      stylua
    ];
  };
}
