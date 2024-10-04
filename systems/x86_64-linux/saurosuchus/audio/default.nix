{...}: {
  services.pipewire.extraConfig.pipewire."monitors" = {
    "context.modules" = [
      {
        name = "libpipewire-module-combine-stream";
        args = {
          "combine.mode" = "sink";
          "node.name" = "monitors";
          "node.description" = "Monitors Auto";
          "combine.latency-compensate" = false;
          "combine.props" = {
            "audio.position" = [ "FL" "FR" ];
          };
          "stream.props" = {
            "stream.dont-remix" = true;
          };
          "stream.rules" = [
            {
              matches = [
                {
                  "media.class" = "Audio/Sink";
                  "node.name" = "alsa_output.pci-0000_0a_00.1.pro-output-7";
                }
              ];
              actions = {
                create-stream = {
                  "audio.position" = [ "AUX0" "AUX1" ];
                  "combine.audio.position" = [ "FL" ];
                };
              };
            }
            {
              matches = [
                {
                  "media.class" = "Audio/Sink";
                  "node.name" = "alsa_output.pci-0000_0a_00.1.pro-output-9";
                }
              ];
              actions = {
                create-stream = {
                  "audio.position" = [ "AUX0" "AUX1" ];
                  "combine.audio.position" = [ "FR" ];
                };
              };
            }
          ];
        };
      }
    ];
  };
}
