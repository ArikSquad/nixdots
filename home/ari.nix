{
  config,
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  home = {
    inherit username;
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
      xdg-terminal-exec

      # dev tools
      nodejs_26
      jdk25
      bun

      # C dev
      gcc

      # nix
      nixfmt

      # desktop apps
      ghostty
      vesktop
      kdePackages.dolphin
      jetbrains-toolbox
      prismlauncher
      t3code
      mongodb-compass
      spotify # unfree software !!!
    ];

    sessionVariables = {
      TERMINAL = "ghostty";
      NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    };

    sessionPath = [
      "${config.home.homeDirectory}/.npm-global/bin"
    ];
  };

  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
  '';

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
    "caelestia/hypr-user.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixdots/config/caelestia/hypr-user.lua";
      recursive = false; # it's a file
      force = true;
    };
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

  programs.git = {
    enable = true;
    package = pkgs.git.override { withLibsecret = true; };
    settings = {
      user = {
        name = "ArikSquad";
        email = "75741608+ArikSquad@users.noreply.github.com";
      };
      init.defaultBranch = "main";
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
