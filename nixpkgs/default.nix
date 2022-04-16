import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixpkgs-unstable-2022-04-16";
  url = "https://github.com/nixos/nixpkgs/archive/faad370edcb37162401be50d45526f52bb16a713.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "1d82d4vh0layf6n925j0h2nym16jbvcvps3l5m8ln9hxn0m6gadn";
})
