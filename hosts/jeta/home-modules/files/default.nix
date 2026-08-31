#TODO: change shebangs with direct path to a system's bash executable
{ pkgs, ... }:
let
  generic = {
    enable = true;
    executable = true;
    force = true;
  };
in
{
  home.packages = with pkgs; [ wf-recorder ];
  home.file = {
    record-script = generic // {
      target = "./execs/record-script.sh";
      source = ./record-script.sh;
    };
  };
}
