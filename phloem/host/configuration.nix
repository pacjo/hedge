{ config, lib, pkgs, ... }:

{
    imports = [
        # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];

    # Enable expermiental nix features
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
    boot.loader.grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf
    boot.loader.generic-extlinux-compatible.enable = true;

    # Networking
    networking = {
        hostName = "phloem";

        networkmanager.enable = true;
        firewall.enable = false;
    };

    # Timezone
    time.timeZone = "Europe/Warsaw";

    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.UTF-8";
    # console = {
    #     font = "Lat2-Terminus16";
    #     keyMap = "us";
    #     useXkbConfig = true; # use xkb.options in tty.
    # };

    users.users.root.initialHashedPassword = "$y$j9T$EdduY8tp9gwlXuugRfIVj0$6TH79Y2Mby/dW4gFzLXBkECevZnQWhm.tc9qHzFMhv4";

    # environment.systemPackages = with pkgs; [
    #     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #     wget
    # ];

    # SSH
    services.openssh = {
        enable = true;
        settings = {
            PermitRootLogin = "yes";
        };
    };

    # This option defines the first version of NixOS installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    system.stateVersion = "26.05";
}
