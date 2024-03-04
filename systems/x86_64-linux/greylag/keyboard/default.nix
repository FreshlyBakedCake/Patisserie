{
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="9000", ATTRS{idProduct}=="400d", MODE="0660", GROUP="dialout"
  '';
}