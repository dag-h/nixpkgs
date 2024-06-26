{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.programs.overwitch;

  overwitch = cfg.package.override {
    withGui = cfg.gui.enable;
  };
in {
  options.programs.overwitch = {
    enable = mkEnableOption "Overwitch, an Overbridge 2 device client for JACK audio";

    package = mkOption {
      type = types.package;
      default = pkgs.overwitch;
      defaultText = "pkgs.overwitch";
      description = "Set version of overwitch package to use.";
    };

    gui.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the overwitch GUI application.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ overwitch ];
    services.udev.packages = [ overwitch ];
  };

  meta.maintainers = with lib.maintainers; [ dag-h ];
}
