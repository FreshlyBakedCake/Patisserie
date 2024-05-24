{ config, ... }:
{
  powerManagement = {
    cpuFreqGovernor = "powersave";
    cpufreq.max = 1500000;
    # Running at full frequency heats up too much and throttles us, we can do it for a little but we should actively set it iff we need it
  };
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
