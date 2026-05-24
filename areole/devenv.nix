{ pkgs, lib, config, ... }:
{
  languages.cplusplus.enable = true;

  packages = with pkgs; [
    tio
    esptool
    platformio-core
  ];
}
