{ pkgs ? import ./pkgs.nix {},
  vim ? import ./vim.nix {},
  channel ? "stable",
  version ? "1.60.0",
}:

let
  deps = with pkgs; [
    rust-bin."${channel}"."${version}".default
    rustfmt
    rust-analyzer
    clippy
  ];

  nvim = vim.nvimCustom vim.rustPlugins;

in
  {
    inherit deps;
    inherit nvim;
  }
