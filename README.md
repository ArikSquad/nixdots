# nixdots

my nix configuration (not really dotfiles) 


if u want to steal it, do this:

1. install a minimal NixOS system.
2. clone this repo to `~/nixdots`.
3. replace `hosts/nixbox/hardware-configuration.nix` with something that works on your hardware:

   ```sh
   sudo nixos-generate-config --show-hardware-config > ~/nixdots/hosts/nixbox/hardware-configuration.nix
   ```

4. review all of the files to make sure they fit your use case.
5. build and switch:

   ```sh
   sudo nixos-rebuild switch --flake ~/nixdots#nixbox
   ```

yes my nix config is mit licensed.

