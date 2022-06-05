{ pkgs, rnix-lsp }:

let
  rnix-lsp-pkg = rnix-lsp.defaultPackage."${pkgs.stdenv.system}";
in
{
  all = [ rnix-lsp-pkg ];
  rnix-lsp = rnix-lsp-pkg;
}
