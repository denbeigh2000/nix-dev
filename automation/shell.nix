{ pkgs ? import ../pkgs.nix { } }:

let
  python = pkgs.python310.withPackages (p: with p; [
    click
    requests
    python-dateutil
  ]);
in
{
  shell = pkgs.mkShell {
    buildInputs = [
      python
      pkgs.nix
      pkgs.git
      pkgs.cacert
    ];
    shellHook = ''
      PYTHONPATH=${python}/${python.sitePackages}
    '';
  };
}
