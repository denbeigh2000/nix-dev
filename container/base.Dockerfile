FROM debian:buster-slim
RUN useradd -u 1000 dev
RUN mkdir /home/dev && chown dev /home/dev

FROM scratch
COPY --from=0 /etc/passwd /etc/passwd
COPY --from=0 /home /home
