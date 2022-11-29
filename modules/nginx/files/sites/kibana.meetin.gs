server {
  listen      80 default_server;
  server_name kibana.meetin.gs;

  root /usr/share/nginx/html;
  index index.html;

  auth_basic "You shall not pass";
  auth_basic_user_file /etc/nginx/passwd;

  location / {
    try_files $uri $uri/ =404;
  }

  location /elasticsearch {
    proxy_pass http://127.0.0.1:9200/;
    proxy_redirect off;
  }
}
