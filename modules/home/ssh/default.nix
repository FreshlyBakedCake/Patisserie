{ pkgs
, ...
}: {
  services.ssh-agent.enable = true;

  systemd.user.services.ssh-agent-add = {
    Unit = {
      Description = "Automatically add ssh keys to the ssh-agent";
      After = "ssh-agent.service";
      Requires = "ssh-agent.service";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/sh -c 'SSH_AUTH_SOCK=%t/ssh-agent ${pkgs.openssh}/bin/ssh-add'";
    };

    Install.WantedBy = [ "default.target" ];
  };
}
