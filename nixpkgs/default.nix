import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixpkgs-unstable-2022-05-28";
  url = "https://github.com/nixos/nixpkgs/archive/17b62c338f2a0862a58bb6951556beecd98ccda9.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "1yzbc85m9vbhsfprljzjkkskh9sxchid9m28wkgwsckqnf47r911";
})
