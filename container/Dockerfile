FROM nixos/nix:2.7.0

# # https://github.com/LnL7/nix-docker/issues/17#issuecomment-580304206
# RUN nix-shell \
#     --packages '(import /etc/nix/conf/pkgs.nix {}).shadow.override { pam = null; }' \
#     --run 'useradd denbeigh'

RUN mkdir -p /etc/nix/conf
ADD *.nix /etc/nix/conf/
ADD container/*.nix /etc/nix/conf/container/
WORKDIR /etc/nix/conf/container

RUN nix-env --install -A pkgset -f /etc/nix/conf/container/default.nix

# RUN useradd denbeigh && mkdir -p /home/denbeigh && chown denbeigh /home/denbeigh
# WORKDIR /home/denbeigh
# USER denbeigh
