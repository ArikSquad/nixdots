{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
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

  screenshot-select = pkgs.writeShellApplication {
    name = "screenshot-select";
    runtimeInputs = with pkgs; [
      coreutils
      grim
      hyprland
      jq
      libnotify
      slurp
      wl-clipboard
    ];
    text = ''
      windows="$(
        hyprctl clients -j |
          jq -r '.[] | select(.mapped) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
      )"

      geometry="$(slurp -d <<< "$windows")" || exit 0

      screenshot_dir="''${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
      mkdir -p "$screenshot_dir"
      destination="$screenshot_dir/$(date +%Y-%m-%d_%H-%M-%S).png"

      grim -g "$geometry" - | tee "$destination" | wl-copy
      notify-send -a screenshot-select -i "$destination" "Screenshot captured" \
        "Saved to $destination and copied to the clipboard"
    '';
  };
in
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
    packages = (with pkgs; [
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
      screenshot-select

      # dev tools
      nodejs_26
      jdk25
      bun

      # C/C++ dev
      cmake
      gcc
      gnumake
      ninja

      # go
      go

      # GitHub CLI
      gh

      # ai slopfest
      opencode

      # Rust dev
      cargo
      cargo-tauri
      clippy
      rust-analyzer
      rustc
      rustfmt
      glib
      pkg-config
      gtk3
      at-spi2-core
      gdk-pixbuf
      pango
      cairo
      webkitgtk_4_1
      libsoup_3
      openssl

      # aseprite
      aseprite

      # nix
      nixfmt

      # desktop apps
      ghostty
      vesktop
      kdePackages.dolphin
      jetbrains-toolbox
      prismlauncher
      t3code
      # mongodb-compass
    ]) ++ nativeLibraries;

    sessionVariables = {
      TERMINAL = "ghostty";
      NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
      PKG_CONFIG_PATH = pkgConfigPath;
    };

    sessionPath = [
      "${config.home.homeDirectory}/.npm-global/bin"
    ];
  };

  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
  '';

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

  home.sessionVariables.LIBVA_DRIVER_NAME = "radeonsi";

  programs.home-manager.enable = true;
  programs.spicetify.enable = true;
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
    "caelestia/hypr-vars.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixdots/config/caelestia/hypr-vars.lua";
      recursive = false;
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
