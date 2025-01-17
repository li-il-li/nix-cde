{ config, lib, pkgs, ... }:

{
  options = with lib; {
    go = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "go";

          go = mkOption {
            type = types.package;
            description = "go package used";
            example = "pkgs.go_1_18";
            default = pkgs.go;
          };

          modules = mkOption {
            type = types.path;
            description = "path to gomod2nix.toml file";
            default = config.src + "/gomod2nix.toml";
          };
        };
      };
    };

    out_go = mkOption {
      type = types.package;
      readOnly = true;
    };
  };

  config = let
    cfg = config.go;
  in lib.mkIf cfg.enable {
    out_go = pkgs.buildGoApplication {
      pname = config.name;
      version = config.version;
      src = config.src;
      modules = cfg.modules;
    };
    dev_commands = [
      pkgs.gomod2nix
    ];
    dev_apps = [
      cfg.go
    ];
  };
}
