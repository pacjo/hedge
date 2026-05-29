{ config, lib, pkgs, ... }:

let
  iface   = "wlan0";
  uplink  = "enu1u1";
  gateway = "10.0.0.1";
  proxyPort = 8080;
in
{
    # Ensure WiFi firmware is available (RPi3 needs brcmfmac) - TODO: mkForce needed?
    hardware.enableRedistributableFirmware = lib.mkForce true;

    # Disable wireless client entirely
    networking.wireless.enable = lib.mkForce false;

    # Keep NetworkManager for ethernet uplink, but hands off wlan0
    networking.networkmanager.unmanaged = [ "interface-name:${iface}" ];

    # Static IP on the AP interface
    networking.interfaces.${iface}.ipv4.addresses = [{
        address = gateway;
        prefixLength = 24;
    }];

    # Enable IP forwarding
    boot.kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
    };

    # Configure access point
    services.hostapd = {
        enable = true;
        radios.${iface} = {
            countryCode = "PL";
            channel = 7;

            # configure capabilities
            wifi4.capabilities = [];  # remove all HT caps the driver can't honour
            wifi5.enable = false;     # no 5 GHz on BCM43430
            wifi6.enable = false;     # no 802.11ax either

            networks.${iface} = {
                ssid = "phloem";
                # authentication.mode = "none";
                authentication = {
                    mode = "wpa2-sha1";
                    wpaPassword = "password";
                };
                settings = {
                    ieee80211w = 0;                     # disable PMF — BCM43430 can't do it
                    ap_isolate = lib.mkForce true;      # force client-to-client traffic through the host stack - TODO: not sure this is working fully
                    wpa_pairwise = "CCMP";
                    rsn_pairwise = "CCMP";
                };
            };
        };
    };

    # Make sure hostapd can actually claim the interface
    systemd.services.hostapd = {
        after = [ "network-pre.target" "NetworkManager.service" ];
        serviceConfig.ExecStartPre = lib.mkBefore [
            "${pkgs.util-linux}/bin/rfkill unblock wifi"
            "${pkgs.iproute2}/bin/ip link set ${iface} down"
            "${pkgs.coreutils}/bin/sleep 1"
            "${pkgs.iproute2}/bin/ip link set ${iface} up"
        ];
    };

    # DNS + DHCP
    services.dnsmasq = {
        enable = true;
        settings = {
            interface = iface;
            bind-interfaces = true;
            dhcp-range = [ "10.0.0.10,10.0.0.254,24h" ];
            dhcp-option = [
                "3,${gateway}"
                "6,${gateway}"
            ];
        };
    };

    # iptables: NAT + transparent redirect
    systemd.services.mitm-iptables = {
        description = "NAT and transparent mitmproxy redirect";
        after  = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
        };
        path = [ pkgs.iptables ];
        script = ''
            iptables -t nat -A POSTROUTING -o ${uplink} -j MASQUERADE
            iptables -A FORWARD -i ${iface} -o ${uplink} -j ACCEPT
            iptables -A FORWARD -i ${uplink} -o ${iface} -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
            iptables -t nat -A PREROUTING -i ${iface} -p tcp --dport 80  -j REDIRECT --to-port ${toString proxyPort}
            iptables -t nat -A PREROUTING -i ${iface} -p tcp --dport 443 -j REDIRECT --to-port ${toString proxyPort}
        '';
        preStop = ''
            iptables -t nat -D POSTROUTING -o ${uplink} -j MASQUERADE || true
            iptables -D FORWARD -i ${iface} -o ${uplink} -j ACCEPT || true
            iptables -D FORWARD -i ${uplink} -o ${iface} -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT || true
            iptables -t nat -D PREROUTING -i ${iface} -p tcp --dport 80  -j REDIRECT --to-port ${toString proxyPort} || true
            iptables -t nat -D PREROUTING -i ${iface} -p tcp --dport 443 -j REDIRECT --to-port ${toString proxyPort} || true
        '';
    };
}
