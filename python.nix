{ pkgs ? import ./pkgs.nix {},
  vim ? import ./vim.nix {}
}:

let
  deps = with pkgs; [
    python310
    python310Packages.python-lsp-server
    python310Packages.pynvim
  ];

  nvim = vim.nvimCustom vim.pythonPlugins;

in
  {
    inherit deps;
    inherit nvim;
  }
