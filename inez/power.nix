{ pkgs, config, ... }:
{
  services.power-profiles-daemon.enable = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "powersave";
  };
}
