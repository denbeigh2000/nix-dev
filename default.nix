{ pkgs ? import ./pkgs.nix {},
  rust_channel ? "stable",
  rust_version ? "1.60.0",
}:

let
  base = with pkgs; [
    curl
  ];

  interactive = import ./interactive.nix {};
  go = import ./go.nix {};
  rust = import ./rust.nix {
    channel = rust_channel;
    version = rust_version;
  };
  python = import ./python.nix {};
  vim = import ./vim.nix {};

  fullInteractive = base ++ interactive.base ++ python.deps ++ rust.deps ++ go.deps ++ [(vim.nvimCustom vim.allPlugins)];

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
