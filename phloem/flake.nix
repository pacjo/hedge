{
    description = "Phloem system flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        ngipkgs.url = "github:ngi-nix/ngipkgs";

        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    };

    outputs = { self, nixpkgs, ngipkgs, nixos-hardware, ... }@inputs: {
        nixosConfigurations = {
            phloem = nixpkgs.lib.nixosSystem {
                system = "aarch64-linux";
                specialArgs = { inherit inputs; };
                modules = [
                    # nixos hardware specifics
                    nixos-hardware.nixosModules.raspberry-pi-3

                    # main config
                    ./host/configuration.nix

                    # modules
                    ./modules/mitmproxy.nix
                    ./modules/mitm-ap.nix
                ];
            };
        };
    };
}
