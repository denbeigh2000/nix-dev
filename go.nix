{ pkgs ? import ./pkgs.nix { }
, vim ? import ./vim.nix { }
}:

{
  deps = with pkgs; [ go ];
  nvim = vim.nvimCustom vim.goPlugins;
}
