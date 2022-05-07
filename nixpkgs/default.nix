import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixpkgs-unstable-2022-05-07";
  url = "https://github.com/nixos/nixpkgs/archive/2fdb6f2e08e7989b03a2a1aa8538d99e3eeea881.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "12wfjn35j9k28jgp8ihg96c90lqnplfm5r2v5y02pbics58lcrbw";
})
