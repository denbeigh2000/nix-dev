{ pkgs ? import ./pkgs.nix {},
  vim ? import ./vim.nix {}
}:

let
  deps = with pkgs; [
    rustc
    rustfmt
    rust-analyzer
    cargo
    clippy
  ];

  nvim = vim.nvimCustom vim.rustPlugins;

in
  {
    inherit deps;
    inherit nvim;
  }
