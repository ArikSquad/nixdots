{ ... }: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 1;
    limine = {
      enable = true;
      efiSupport = true;
      maxGenerations = 5;
    };
  };
}
