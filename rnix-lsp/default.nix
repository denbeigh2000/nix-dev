import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "rnix-lsp-2022-05-07";
  url = "https://github.com/nix-community/rnix-lsp/archive/e09b2858243ffcf5776ee787b9e3c8d8afb23967.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "0hz0kcj98nqf4k3icdxh2xnqzr7p0zkw82ysd08vfq8qx3pg9w1i";
})
