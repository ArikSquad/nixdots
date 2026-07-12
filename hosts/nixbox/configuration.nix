{
  inputs,
  username,
  hostname,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/boot/limine.nix
    ../../modules/desktop/greetd.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/programs/fish.nix
    ../../modules/programs/helium.nix
    ../../modules/programs/steam.nix
  ];

  networking.hostName = hostname;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
  };

  system.stateVersion = "26.05";
}
