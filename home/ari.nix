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
      # desktop apps, move away from here tbh or idk does it even matter?
      nodejs_26
      bun
      vesktop
      kdePackages.dolphin
    ];
  };

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

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
    userName = "Ari";
    userEmail = "ari@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      lua-language-server
      nil
      nixd
      bash-language-server
      stylua
    ];
    plugins = with pkgs.vimPlugins; [
      blink-cmp
      conform-nvim
      fzf-lua
      gitsigns-nvim
      kanagawa-nvim
      lualine-nvim
      mini-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      oil-nvim
      snacks-nvim
      which-key-nvim
    ];
    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.signcolumn = "yes"
      vim.opt.termguicolors = true
      vim.opt.updatetime = 250
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.cmd.colorscheme("kanagawa")

      require("mini.icons").setup()
      require("oil").setup()
      require("gitsigns").setup()
      require("which-key").setup()
      require("lualine").setup({ options = { theme = "auto" } })
      require("fzf-lua").setup()
      require("blink.cmp").setup()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          nix = { "alejandra" },
        },
      })

      local lsp = require("lspconfig")
      lsp.nil_ls.setup({})
      lsp.nixd.setup({})
      lsp.lua_ls.setup({})
      lsp.bashls.setup({})

      vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>")
      vim.keymap.set("n", "<leader>f", require("fzf-lua").files)
      vim.keymap.set("n", "<leader>g", require("fzf-lua").live_grep)
      vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
    '';
  };
}
