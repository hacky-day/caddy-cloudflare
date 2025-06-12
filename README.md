# Caddy + Cloudflare

Automatically built Caddy containers with Cloudflare DNS plugin included.


## Docker Compose Example

```yaml
services:
  caddy:
    image: ghcr.io/hacky-day/caddy-cloudflare:latest
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    volumes:
      - ./conf:/etc/caddy
      - caddy_data:/data
      - caddy_config:/config

volumes:
  caddy_data:
  caddy_config:
```


## Caddyfile Example

```json5
{
    email jdoe@example.com
    cert_issuer acme {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
}

example.com {
    reverse_proxy backend:8080
}
```
