> [!NOTE]  
> Updating most likely won't be necessary, but might come in handy if you want to change the configuration.

# Updating

> [!TIP]
> Stock nix tooling can be used, but the manual below will use [nh](https://github.com/nix-community/nh).

1. make sure you have connection to the device (KDE Plasma network sharing can be used as an example)
2. from the [`phloem`](..) directory run:
    ```bash
    nh os switch . --hostname phloem --target-host root@<device_ip_address>
    ```
3. some changes may require a reboot. SSH is configured and can be used for that.
