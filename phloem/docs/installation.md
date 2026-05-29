> [!NOTE]  
> installation somewhat follows: https://www.eisfunke.com/posts/2023/nixos-on-raspberry-pi.html

# Requirements

- 16GB sd card
- PC running NixOS
    - if it's not aarch64 based (and it probably isn't, then adding the following to configuration is required):
        ```nix
        boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
        ```


# Building and flashing

1. from [`phloem`](..) directory run:
    ```
    nixos-rebuild build-image --image-variant sd-card --flake .#phloem
    ```
2. burn resulting image to sd with rpi-imager or similar tool


# Usage

1. connect the rpi to pc with ethernet cable
2. on the pc select an option like (*Shared to other computers* (in case of KDE Plasma) in wired network settings)
3. default root password is `phloem` and should be changed upon login
4. `mitmproxy` and `mitmweb` should be running and be accessible at <rpi-ip>:8081
