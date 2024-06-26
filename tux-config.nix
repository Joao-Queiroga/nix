# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.supportedFilesystems = [ "ntfs" ];
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/558bc3be-4d67-481b-ae8d-fd334b7e95ac";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd:7" "space_cache=v2" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/558bc3be-4d67-481b-ae8d-fd334b7e95ac";
    fsType = "btrfs";
    options = [ "subvol=@var" "compress=zstd:7" "space_cache=v2" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/9933da03-c31f-4fc9-bbf2-986d55d82d9a";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd:7" "space_cache=v2" ];
  };

  fileSystems."/mnt/hd" = {
    device = "/dev/disk/by-uuid/CC9859CE9859B822";
    fsType = "ntfs-3g";
    options = [ "rw" ];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/B6F2-55CF";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
