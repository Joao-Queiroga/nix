# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/544f2498-f200-4e71-a4a8-26dbab80cb55";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd:7" "space_cache=v2" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/00cfd66b-d0c3-4a5a-9ffd-cf71badfc85d";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd:7" "space_cache=v2" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/64B8-EF51";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/29525ea8-917c-4e5c-a1b6-d2fa56a9b656"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
