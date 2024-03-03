# NixOS Configs

## Overview

This repository contains all the NixOS configurations I use on my home network.
In addition to all that, there's an output in the flake called `srvProxy` which
can be used to simultaneously configure dnsmasq and caddy to reverse proxy a
couple services running on the same machine. If you'd like to use it for your
own system(s), do raise an issue or email me and I'll polish it up for more
general use.
