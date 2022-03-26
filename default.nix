{ pkgs ? import ./pkgs.nix {} }:

let
  base = with pkgs; [
    curl
  ];

  interactive = import ./interactive.nix {};
  go = import ./go.nix {};
  rust = import ./rust.nix {};
  python = import ./python.nix {};
  vim = import ./vim.nix {};

  fullInteractive = base ++ interactive.base ++ python.deps ++ rust.deps ++ go.deps;

in
  {
    inherit go;
    inherit rust;
    inherit python;

    inherit interactive;
    inherit fullInteractive;

    inherit vim;

    pythonShell = pkgs.mkShell {
      packages = interactive.base ++ python;
    };

    rustShell = pkgs.mkShell {
      packages = interactive.base ++ rust;
    };

    goShell = pkgs.mkShell {
      packages = interactive.base ++ go;
    };

    shell = pkgs.mkShell {
      packages = fullInteractive;
    };
  }
