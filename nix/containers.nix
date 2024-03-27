{
  containers.demo = {
    privateNetwork = true;
    hostAddress = "10.250.0.1";
    localAddress = "10.250.0.2";

    config = { pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ 50 ];

      systemd.services.hello = {
        wantedBy = [ "multi-user.target" ];
        script = "while true; do echo hello1 | ${pkgs.netcat}/bin/nc -lN 50; done";
      };
    };
  };

  containers.demo2 = {
    privateNetwork = true;
    hostAddress = "10.250.0.1";
    localAddress = "10.250.0.3";

    config = { pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ 50 ];

      systemd.services.hello = {
        wantedBy = [ "multi-user.target" ];
        script = "while true; do echo hello2 | ${pkgs.netcat}/bin/nc -lN 50; done";
      };
    };
  };
}
