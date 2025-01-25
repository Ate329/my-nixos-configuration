{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.amdgpu;
in
{
  options.drivers.amdgpu = {
    enable = mkEnableOption "Enable AMD Drivers";
  };

  config = mkIf cfg.enable {
    # pkgs.rocmPackages_5.clr
    systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.cpu.amd.updateMicrocode = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        mesa
        amdvlk
        # rocmPackages_5.clr.icd
        rocmPackages.clr.icd
        rocmPackages.rccl
        rocmPackages.half
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        mesa
        amdvlk
      ];
    };
  };
}
