import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "rust-overlay-2022-05-28";
  url = "https://github.com/oxalica/rust-overlay/archive/0be302358da0f8ea3d3cc24a0639b6354fc45e7c.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "1gk3k5a482wz0y4k8wdgq7fz2qz1lwswgsqw65rlyy4zp66129d5";
})
