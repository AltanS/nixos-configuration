{ config, pkgs, userSpecificData, ... }:
{
  programs.ssh = {
    enable = true;
  };
} 