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

  config = mkIf cfg.enable (
    let
      # Combine required ROCm libraries for HIP
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          # Common compute libraries
          rocblas
          hipblas
          rocsolver
          hipsparse
          rocfft
          # Needed for OpenCL/HIP runtime itself
          clr
          # From your existing config (also needed in combined env)
          rccl
          half
        ];
      };
    in
    {
      # Link the combined env to /opt/rocm where apps expect it
      systemd.tmpfiles.rules = [ "L+    /opt/rocm   -    -    -     -    ${rocmEnv}" ];

      hardware.cpu.amd.updateMicrocode = true;

      hardware.graphics = {
        enable = true;
        enable32Bit = true;

        # Include the base ICD loader needed for OpenCL/HIP
        # Other libraries are provided via the /opt/rocm link
        extraPackages = with pkgs; [
          mesa
          rocmPackages.clr.icd # ICD needed for applications to find OpenCL/HIP
          rocmPackages.rccl # Keep explicit dependencies needed elsewhere
          rocmPackages.half
        ];
        extraPackages32 = with pkgs.driversi686Linux; [ mesa ];
      };
    }
  );
}
