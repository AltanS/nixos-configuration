{ config, lib, pkgs, ... }:

{
  # Automatically detect if we're in a VM by checking for the QEMU module
  # or other VM-specific hardware
  config = let
    # Detect if we're running in a VM
    isVM = builtins.any (mod: builtins.match ".*virtio.*" mod != null) 
           config.boot.initrd.availableKernelModules ||
           builtins.any (mod: builtins.match ".*vm.*" mod != null)
           (config.boot.kernelModules ++ config.boot.initrd.availableKernelModules);
    
    # Find the likely boot disk
    bootDisk = if config.fileSystems ? "/boot" then
                 lib.removePrefix "/dev/" config.fileSystems."/boot".device
               else if config.fileSystems ? "/" then
                 lib.removePrefix "/dev/" (
                   if lib.hasPrefix "/dev/" config.fileSystems."/".device
                   then config.fileSystems."/".device
                   else "/dev/sda") # Fallback
               else
                 "sda"; # Default fallback
    
    # Extract just the disk name without partitions
    extractDiskName = dev:
      let
        # Remove partition numbers
        noPartition = builtins.replaceStrings ["/dev/"] [""] (
          if lib.hasInfix "nvme" dev
          then builtins.head (builtins.split "p[0-9]+" dev)
          else builtins.head (builtins.split "[0-9]+" dev)
        );
      in
        if lib.hasPrefix "/dev/" dev 
        then "/dev/${noPartition}"
        else if lib.hasPrefix "LABEL=" dev || lib.hasPrefix "UUID=" dev
        then "/dev/sda" # Fallback for UUIDs/LABELs
        else "/dev/${noPartition}";
    
    # Determine the actual boot device
    bootDevice = extractDiskName 
                  (if config.fileSystems ? "/boot" 
                   then config.fileSystems."/boot".device
                   else if config.fileSystems ? "/" 
                   then config.fileSystems."/".device
                   else "/dev/sda");
  in {
    # VM-specific configuration
    boot.loader = if isVM then {
      # Use GRUB for VMs (more compatible with VM environments)
      grub = {
        enable = true;
        device = bootDevice;
        useOSProber = true;
      };
    } else {
      # Use systemd-boot for physical hardware (assumes UEFI)
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Print the boot configuration during build for debugging
    warnings = [ 
      "Boot configuration: ${if isVM then "VM mode with GRUB on ${bootDevice}" 
                            else "Physical hardware mode with systemd-boot"}"
    ];
  };
} 