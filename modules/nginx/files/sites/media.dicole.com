server {
    listen      80;
    listen      443;
    server_name media.dicole.com;

    ssl_certificate     /etc/letsencrypt/live/dicolelivebundle/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/dicolelivebundle/privkey.pem;

    if ($scheme = http) {
        return 302 https://$host$request_uri;
    }

    location ^~ /.well-known/acme-challenge/ {
        default_type "text/plain";
        root         /var/www/letsencrypt;
    }

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://legacy_media_pool;
    }
}
