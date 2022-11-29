# This is a copy of the meetings catchall with one rule added in the bottom
# This was the only way to redirect 'http://meetin.gs/' to 'https://www.meetin.gs/'
# that I knew which did not redirect also other domains there.

server {
    listen 80;
    listen 443 ssl;

    server_name meetin.gs;

    ssl_certificate     /etc/ssl/private/meetings.pem;
    ssl_certificate_key /etc/ssl/private/meetings.pem;

    underscores_in_headers on;

    location ~ ^/apigw/(.*)$ {
        proxy_connect_timeout       300s;
        proxy_send_timeout          300s;
        proxy_read_timeout          300s;
        send_timeout                300s;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://live_api_pool/$1$is_args$args;
    }

    location /reproxy {
      internal;

      if ($upstream_http_x_reproxy_url ~ "^([^ ]+)(?:\s+([^ ]+))?") {
        set $reproxy1 $1;
        set $reproxy2 $2;
      }

      proxy_intercept_errors on;
      error_page 404 500 502 503 504 = @reproxy2;

      proxy_pass $reproxy1;
    }

    location @reproxy2 {
        add_header 'Content-Type' $upstream_http_x_content_type;
        proxy_pass $reproxy2;
    }

    location ~ ^/(?:meetings_appdirect)/$ {
        proxy_connect_timeout       300s;
        proxy_send_timeout          300s;
        proxy_read_timeout          300s;
        send_timeout                300s;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://live_http_core_pool;
    }

    location / {
        proxy_connect_timeout       300s;
        proxy_send_timeout          300s;
        proxy_read_timeout          300s;
        send_timeout                300s;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://dcp_core_pool;
    }

    location ~ ^/?$ {
        return 307 https://www.meetin.gs/;
    }
}

#### Catchall copy ends here. The rest are normal redirects.

server {
    listen 80;
    listen 443 ssl;

    server_name support.meetin.gs;

    ssl_certificate     /etc/ssl/private/meetings.pem;
    ssl_certificate_key /etc/ssl/private/meetings.pem;

    location / {
        return 307 https://meetings.zendesk.com;
    }
}

server {
    listen 80;
    listen 443 ssl;

    server_name elisa.meetin.gs;

    ssl_certificate     /etc/ssl/private/meetings.pem;
    ssl_certificate_key /etc/ssl/private/meetings.pem;

    location / {
        return 307 https://videra.meetin.gs/$1$is_args$args;
    }
}

