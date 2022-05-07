{ pkgs ? (import ./pkgs.nix {}),
  rust_channel ? "stable",
  rust_version ? "1.60.0",
}:

let
  base = with pkgs; [
    curl
  ];

  cli = import ./automation/default.nix { inherit (pkgs); };

  interactive = import ./interactive.nix { inherit (pkgs); };
  go = import ./go.nix { inherit (pkgs); };
  rust = import ./rust.nix {
    channel = rust_channel;
    version = rust_version;
  };
  python = import ./python.nix { inherit (pkgs); };
  vim = import ./vim.nix { inherit (pkgs); };

  fullInteractive = base
    ++ interactive.base
    ++ python.deps
    ++ rust.deps
    ++ go.deps
    ++ [(vim.nvimCustom vim.allPlugins)]
    ++ vim.rnix-lsp;

in
  {
    inherit pkgs;

    inherit go;
    inherit rust;
    inherit python;

    inherit interactive;
    inherit fullInteractive;

    inherit vim;

    inherit cli;

    pythonShell = pkgs.mkShell {
      packages = interactive.base ++ python.deps ++ [python.nvim];
    };

    rustShell = pkgs.mkShell {
      packages = interactive.base ++ rust.deps ++ [rust.nvim];
    };

    goShell = pkgs.mkShell {
      packages = interactive.base ++ go.deps ++ [go.nvim];
    };

    shell = pkgs.mkShell {
      packages = fullInteractive;
    };
  }
