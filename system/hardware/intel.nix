# Intel CPU/GPU hardware configuration
{ pkgs, ... }: {
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
    ];
  };

  # CPU microcode updates
  hardware.cpu.intel.updateMicrocode = true;
}
