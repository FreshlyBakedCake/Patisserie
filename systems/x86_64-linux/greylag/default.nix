{ ... }:
{
  imports = [
    ./boot/filesystems
    ./boot/initrd
    ./console
    ./cpu
    ./firmware
    ./networking
    ./time
    ./users
  ];
}
