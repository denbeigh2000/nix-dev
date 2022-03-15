{ pkgs ? import ../pkgs.nix {} }:

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
      ];
      shellHook = ''
        PYTHONPATH=${python}/${python.sitePackages}
      '';
    };
  }
