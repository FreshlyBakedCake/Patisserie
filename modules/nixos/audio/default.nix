{ ... }:
{
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire."virtual-audio-device" = {
      "context.objects" = [
        {
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "Microphone-Proxy";
            "node.description" = "Microphone";
            "media.class" = "Audio/Source/Virtual";
            "audio.posistion" = "MONO";
          };
        }
      ];
    };
  };
}
