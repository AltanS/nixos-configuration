{ pkgs, ... }: {
  gitUsername = "Altan Sarisin";
  gitEmail = "altan.sarisin@gmail.com";
  sshIdentities = [ "~/.ssh/a.sarisin" ];
  extraPackages = with pkgs; [];
}
