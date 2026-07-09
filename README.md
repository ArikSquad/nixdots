# nixdots


1. Install a minimal NixOS system.
2. Clone this repo to `~/nixdots`.
3. Replace `hosts/nixbox/hardware-configuration.nix` with the generated hardware config:

   ```sh
   sudo nixos-generate-config --show-hardware-config > ~/nixdots/hosts/nixbox/hardware-configuration.nix
   ```

4. Review these values:

   - `flake.nix`: `username`, `hostname`, and `system`.
   - `hosts/nixbox/configuration.nix`: `system.stateVersion`.
   - `home/ari.nix`: Git identity, keyboard layout, monitor rule, wallpaper path.

5. Build and switch:

   ```sh
   sudo nixos-rebuild switch --flake ~/nixdots#nixbox
   ```
