{ ... }:
{
  imports = [
    ./boot/filesystems
    ./boot/initrd
    ./boot/logs
    ./console
    ./cpu
    ./credentials/gnome-keyring
    ./credentials/yubikey
    ./firmware
    ./games
    ./keyboard
    ./networking
    ./time
    ./users
  ];
}
