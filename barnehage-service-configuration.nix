# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
     <nixpkgs/nixos/modules/profiles/qemu-guest.nix> 
    ];

  boot.initrd.availableKernelModules = [ "virtio_pci" "ahci" "sd_mod" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/sda";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/sdb"; }
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  boot.kernelParams = [ "console=ttyS0,19200n8" ];
  boot.loader.grub.extraConfig = ''
  serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
  terminal_input serial;
  terminal_output serial;
 '';

  boot.loader.grub.device = "nodev";
  boot.loader.timeout = 10;

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  networking.usePredictableInterfaceNames = false;
   environment.systemPackages = with pkgs; [
     wget vim inetutils mtr sysstat
   ];

  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 22 8000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  system.stateVersion = "18.03"; # Did you read the comment?

  network.description = "barnehageservice";

  barnehageservice =
    { config, pkgs, ... }: let
      barnehageservice = import ./default.nix { inherit pkgs; };
    in
  {
  
    networking.hostName = "barnehageservice";
    deployment.targetHost = "li1813-211.members.linode.com";
    networking.firewall.allowedTCPPorts = [ 22 80 ];
    environment.systemPackages = [ barnehageservice ];

    boot.kernelParams = [ "console=ttyS0,19200n8" ];
    boot.loader.grub.extraConfig = ''
  serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
  terminal_input serial;
  terminal_output serial;
 '';

    services.openssh = {
      enable = true;
      permitRootLogin = "yes";
    };
    systemd.services.barnehageservice =
        { description = "barnehage api";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          serviceConfig =
            { ExecStart = "${barnehageservice}/bin/barnehageservice";
            };
        };
    };
}

