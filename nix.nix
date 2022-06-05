{ pkgs, rnix-lsp }:

let
  rnix-lsp-pkg = rnix-lsp.defaultPackage."${pkgs.stdenv.system}";
in
{
  rnix-lsp = rnix-lsp-pkg;
}
