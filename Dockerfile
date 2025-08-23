FROM caddy:2.10.1-builder AS builder

RUN xcaddy build \
  --with github.com/caddy-dns/cloudflare

FROM caddy:2.10.1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
