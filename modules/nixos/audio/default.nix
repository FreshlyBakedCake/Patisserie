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
  };

  environment.etc."pipewire/pipewire.conf.d/VirtualAudioDevice.conf".text = ''
    context.objects = [
      {
        factory = adapter
        args = {
          factory.name = support.null-audio-sink
          node.name = Microphone-Proxy
          node.description = Microphone
          media.class = Audio/Source/Virtual
          audio.posistion = MONO
        }
      }
    ]
  '';
}
