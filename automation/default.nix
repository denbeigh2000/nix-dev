{ pkgs ? import ../pkgs.nix {} }:

with pkgs;
let
  python-packages = python-packages: with python-packages; [
    click
    requests
    python-dateutil
  ]; 
  python = python310.withPackages python-packages;

  runtime-deps = [git nix cacert];
in 
  python310.pkgs.buildPythonApplication rec {
    name = "cli";
    version = "0.1";

    dontCheck = true;

    propagatedBuildInputs = python-packages python310.pkgs ++ runtime-deps;
    src = ./.;
  }
