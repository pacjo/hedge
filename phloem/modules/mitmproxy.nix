{ config, inputs, ... }:
{
    # config is used to make sure ngipkgs-provided mitmproxy.package is used as in the systemd service

    imports = [
        inputs.ngipkgs.nixosModules.programs.mitmproxy
    ];

    programs.mitmproxy = {
        enable = true;
        swagger.enable = true;
    };

    systemd.services.mitm = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        # TODO: maybe move --set (and future options) to a proper config file
        serviceConfig = {
            Environment = "PYTHONUNBUFFERED=1"; # flush logs immediately
            ExecStart = builtins.concatStringsSep " " [
                "${config.programs.mitmproxy.package}/bin/mitmweb"
                "--mode transparent"
                "--set web_host=0.0.0.0"
                "--set web_password=phloem"
                "--set web_open_browser=false"
            ];
            Restart = "always";
        };
    };
}
