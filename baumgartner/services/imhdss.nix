{ pkgs, lib, imhdss, ... }:

{
  systemd.services.imhdss = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    environment.PATH = lib.mkForce
      "/run/wrappers/bin:/run/current-system/sw/bin";

    serviceConfig = {
      ExecStart = "${imhdss.packages.x86_64-linux.default}/bin/imhdss";
    };
  };

  environment.etc."imhdss/conf.kdl".text = ''
    services {
      imhdss
      dnsmasq
      postgresql
      tailscaled
      wiki-js
      jellyfin
      invokeAI
      paperless-web
      miniflux
    }

    links {
      "wiki.js" url="https://wiki-home.tali.network"
      jellyfin  url="https://jf-home.tali.network"
      radicale  url="https://rd-home.tali.network"
      paperless url="https://pl-home.tali.network"
      miniflux  url="https://rss-home.tali.network"
    }

    meta {
    	slogan "TaliCorp™ has officially divested from all fracking engagements following a Q4 revenue failure."
    	slogan "Please heed the recall of all TaliCorp™ brand metallurgy products."
    	slogan "TaliCorp™ advises all employees to avoid manufacturing sub-section G-9."
    	slogan "TaliCorp™ sincerely does not know how it stays in business. It suspects government subsidies."
      slogan "TaliCorp™ is proud to announce its partnership with Neuralink: We're not quite sure why, either."
      slogan "TaliCorp™ will outlive you."
      slogan "TaliCorp™ is proud to announce that it has 'gone woke'."
    }
  '';
}
