{ ... }:
{
  imports = [
    ./boot/filesystems
    ./boot/initrd
    ./boot/logs
    ./console
    ./cpu
    ./firmware
    ./networking
    ./time
    ./users
  ];
}
