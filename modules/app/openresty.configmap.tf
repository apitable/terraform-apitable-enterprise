resource "kubernetes_config_map" "openresty_config" {
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "openresty-config"
    namespace = var.namespace
  }

  data = {
    "backend-server.conf" = <<-EOT
    location /api {
      proxy_pass   http://backend;
      proxy_set_header X-Real-Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Real-PORT $remote_port;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Original-URI $request_uri;
      proxy_set_header Access-Control-Allow-Headers 'Cookie,Set-Cookie,x-requested-with,content-type';
      proxy_set_header Access-Control-Allow-Origin $http_origin ;
      proxy_set_header 'Access-Control-Allow-Credentials' 'true';
      add_header 'Access-Control-Allow-Methods' 'GET,POST,PUT,OPTIONS';

      proxy_connect_timeout 180s;
      proxy_read_timeout 180s;
      proxy_send_timeout 180s;
    }
    
    location /api/v1/node/readShareInfo {
      proxy_pass   http://backend;
      proxy_set_header X-Real-Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Real-PORT $remote_port;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Original-URI $request_uri;
      proxy_set_header Origin "";
      #Open API cross-domain configuration
      add_header 'Access-Control-Allow-Origin' '*' always;
      add_header 'Access-Control-Allow-Credentials' 'true' always;
      add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, DELETE, PATCH' always;
      add_header 'Access-Control-Allow-Headers' 'Cookie ,Origin, X-Requested-With,Content-Type, Accept' always;
      if ($request_method = 'OPTIONS' ) {
         return 204;
      }
      proxy_connect_timeout 180s;
      proxy_read_timeout 180s;
      proxy_send_timeout 180s;
    }  

     %{if var.has_ai_server}
      location /api/v1/ai {
        proxy_pass   http://backend;
        proxy_set_header X-Real-Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Real-PORT $remote_port;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Original-URI $request_uri;
        proxy_set_header Access-Control-Allow-Headers 'Cookie,Set-Cookie,x-requested-with,content-type';
        proxy_set_header Access-Control-Allow-Origin $http_origin ;
        proxy_set_header 'Access-Control-Allow-Credentials' 'true';
        proxy_buffering off;
        add_header 'Access-Control-Allow-Methods' 'GET,POST,PUT,OPTIONS';

        proxy_connect_timeout 180s;
        proxy_read_timeout 180s;
        proxy_send_timeout 180s;
     }
     %{endif}

    EOT

    "nginx.conf" = <<-EOT
    worker_processes ${var.worker_processes};
    # Enables the use of JIT for regular expressions to speed-up their processing.
    pcre_jit on;

    #error_log  logs/error.log;
    #error_log  logs/error.log  info;
    #pid        logs/nginx.pid;

    events {
        worker_connections 204800;
        multi_accept on;
    }
    http {
        include       mime.types;
        default_type  application/octet-stream;
        log_format json_combined escape=json '{"@timestamp":"$time_iso8601",'
                  '"@source":"$server_addr",'
                  '"@nginx_fields":{'
                  '"remote_addr":"$remote_addr",'
                  '"body_bytes_sent":"$body_bytes_sent",'
                  '"request_time":"$request_time",'
                  '"status":"$status",'
                  '"host":"$host",'
                  '"uri":"$uri",'
                  '"server":"$server_name",'
                  '"request_uri":"$request_uri",'
                  '"request_method":"$request_method",'
                  '"http_referrer":"$http_referer",'
                  '"body_bytes_sent":"$body_bytes_sent",'
                  '"http_x_forwarded_for":"$http_x_forwarded_for",'
                  '"http_user_agent":"$http_user_agent",'
                  '"upstream_response_time":"$upstream_response_time",'
                  '"upstream_status":"$upstream_status",'
                  '"upstream_addr":"$upstream_addr"}}';

        access_log  /dev/stdout json_combined;
        server_tokens off;

        # Configure Gray Shared Dictionary
        lua_shared_dict gray 64m;

        #Max size for file upload
        client_max_body_size  1024m;

        ##cache##
        proxy_buffer_size 16k;
        proxy_buffers 4 64k;
        proxy_busy_buffers_size 128k;
        proxy_cache_path /tmp/cache levels=1:2 keys_zone=cache_one:200m inactive=1d max_size=3g;

        gzip on;
        gzip_proxied any;
        gzip_comp_level 5;
        gzip_buffers 16 8k;
        gzip_min_length 1024;
        gzip_http_version 1.1;
        gzip_types text/plain application/x-javascript text/css text/javascript application/json application/javascript;

        include /etc/nginx/conf.d/upstream/*.conf;
        map $http_upgrade $connection_upgrade {
            default upgrade;
            ''      close;
        }

        server {
              listen 80 default;
              server_name  127.0.0.1;
              charset utf-8;
              error_page 404 502 503   /404;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Real-PORT $remote_port;
              proxy_set_header X-Original-URI $request_uri;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

              include /etc/nginx/conf.d/server/*.conf;

              location =/healthz {
                return 200;
                access_log off;
              }

              location =/robots.txt {
                root /usr/local/openresty/nginx/html;
              }

              ${var.openresty_server_block}
        }

        include /etc/nginx/conf.d/vhost/*.conf;
    }
    EOT

    #Default ssl configuration
    "ssl-default.conf" = ""

    "ssl-host.conf" = <<-EOT
    server {
          listen 443 ssl http2;
          server_name  ${var.server_name};

          ssl_certificate     /etc/nginx/conf.d/certs/tls.crt;
          ssl_certificate_key /etc/nginx/conf.d/certs/tls.key;
          ssl_session_timeout 1d;
          ssl_session_cache shared:MozSSL:10m;  # about 40000 sessions
          ssl_session_tickets off;

          # intermediate configuration
          ssl_protocols TLSv1.2 TLSv1.3;
          ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384;
          ssl_prefer_server_ciphers off;

          charset utf-8;

          #error_page 404 502 503   /404;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Real-PORT $remote_port;
          proxy_set_header X-Original-URI $request_uri;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

          include /etc/nginx/conf.d/server/*.conf;

          ${var.openresty_server_block}

          location =/healthz {
            return 200;
            access_log off;
          }

          location =/robots.txt {
            root /usr/local/openresty/nginx/html;
          }
    }
    EOT

    "room-server.conf" = <<-EOT
    location ~* ^/(actuator|nest) {
      proxy_pass   http://nest-rest;

      proxy_set_header X-Real-Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Real-PORT $remote_port;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Original-URI $request_uri;

      proxy_connect_timeout 180s;
      proxy_read_timeout 180s;
      proxy_send_timeout 180s;
    }

    location /document {
      proxy_pass   http://document;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
      proxy_set_header X-Nginx-Proxy true;
      proxy_set_header Host $host:$server_port;
      proxy_http_version 1.1;
      proxy_connect_timeout 300s;
      proxy_read_timeout 300s;
      proxy_send_timeout 300s;
    }

    %{if var.has_ai_server}
    location ^~ /nest/v1/ai {
      proxy_pass http://nest-rest;

      chunked_transfer_encoding off;
      proxy_buffering off;
      proxy_cache off;
      proxy_http_version 1.1;
      proxy_set_header Connection '';

      proxy_set_header X-Real-Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Real-PORT $remote_port;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Original-URI $request_uri;

      proxy_connect_timeout 180s;
      proxy_read_timeout 180s;
      proxy_send_timeout 180s;
    }
    %{endif}
    EOT

    "fusion-server.conf" = <<-EOT
    location /fusion {
      proxy_pass   http://fusion;
      proxy_next_upstream error http_502 non_idempotent;
      proxy_next_upstream_tries 3;
      error_page 404 503 /404;

      proxy_set_header X-Real-Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Real-PORT $remote_port;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Original-URI $request_uri;
      #Open API cross-domain configuration
      add_header 'Access-Control-Allow-Origin' '*' always;
      add_header 'Access-Control-Allow-Credentials' 'true' always;
      add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, DELETE, PATCH' always;
      add_header 'Access-Control-Allow-Headers' 'Authorization,DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range,x-vika-user-agent' always;
      if ($request_method = 'OPTIONS' ) {
         return 204;
      }
      proxy_connect_timeout 180s;
      proxy_read_timeout 180s;
      proxy_send_timeout 180s;
    }
    EOT

    "socket-server.conf" = <<-EOT
    location /room {
      proxy_pass   http://socketRoom;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
      proxy_set_header X-Nginx-Proxy true;
      proxy_set_header Host $host:$server_port;
      proxy_http_version 1.1;
      proxy_connect_timeout 300s;
      proxy_read_timeout 300s;
      proxy_send_timeout 300s;
    }

    location /notification {
      proxy_pass   http://socket;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
      proxy_set_header X-Nginx-Proxy true;
      proxy_set_header Host $host:$server_port;
      proxy_http_version 1.1;
      proxy_connect_timeout 300s;
      proxy_read_timeout 300s;
      proxy_send_timeout 300s;
    }
    EOT

    "ai-server.conf" = <<-EOT
    %{if var.has_ai_server}
    # location /ai {
    #   proxy_pass   http://ai-server;
    #   proxy_set_header X-Real-Host $http_host;
    #   proxy_set_header X-Real-IP $remote_addr;
    #   proxy_set_header X-Real-PORT $remote_port;
    #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    #   proxy_set_header X-Original-URI $request_uri;
    #   proxy_set_header Access-Control-Allow-Headers 'Cookie,Set-Cookie,x-requested-with,content-type';
    #   proxy_set_header Access-Control-Allow-Origin $http_origin ;
    #   proxy_set_header 'Access-Control-Allow-Credentials' 'true';
    #   proxy_buffering off;
    #   add_header 'Access-Control-Allow-Methods' 'GET,POST,PUT,OPTIONS';

    #   proxy_connect_timeout 180s;
    #   proxy_read_timeout 180s;
    #   proxy_send_timeout 180s;
    # }

    %{endif}
    EOT

    "ups-ai-server.conf" = <<-EOT
    %{if var.has_ai_server}
    upstream ai-server {
       server ai-server:8626;
    }
    %{endif}
    
    EOT

    "databus-server.conf" = <<-EOT
    %{if var.has_databus_server}
    location /fusion/v3 {
      proxy_pass   http://databus-server;

      proxy_set_header X-Real-Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Real-PORT $remote_port;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Original-URI $request_uri;

      proxy_connect_timeout 180s;
      proxy_read_timeout 180s;
      proxy_send_timeout 180s;
    }

    %{endif}
    EOT

    "ups-databus-server.conf" = <<-EOT
    %{if var.has_databus_server}
    upstream databus-server {
       server databus-server:8625;
    }
    %{endif}
    
    EOT

    "job-admin-server.conf" = <<-EOT
    #URI aligns the context-path of the service environment variable (guaranteed that after the service is redirected, it can still be routed to the service)
    %{if var.has_job_admin_server}
    location /job-admin {
      proxy_pass   http://job-admin-server;
    }
    %{endif}
    EOT

    "ups-job-admin-server.conf" = <<-EOT
    %{if var.has_job_admin_server}
    upstream job-admin-server  {
       server ${var.job_admin_server_host}:8080;
    }
    %{endif}
    EOT

    "ups-backend-server.conf" = <<-EOT
    upstream backend  {
       server backend-server:8081;
    }
    EOT

    "ups-room-server.conf" = <<-EOT
    upstream room  {
       server room-server:3333;
    }
    upstream nest-rest  {
       server nest-rest-server:3333;
    }
    upstream document  {
       server document-server:3006;
    }
    EOT

    "ups-fusion-server.conf" = <<-EOT
    upstream fusion  {
       server fusion-server:3333 max_fails=0;
       server fusion-server:3333 max_fails=0;
       server fusion-server:3333 max_fails=0;
    }

    EOT

    "ups-socket-server.conf" = <<-EOT
    upstream socket  {
       server socket-server:3002;
    }
    upstream socketRoom  {
       server socket-server:3005;
    }
    EOT

    "ups-web-server.conf" = <<-EOT
    upstream web-server {
       server web-server:8080;
    }
    EOT

    "web-server.conf" = <<-EOT
    #Default official website path
    location / {
       proxy_set_header X-Nginx-Proxy true;
       proxy_set_header Host %{if var.default_server_host_override_proxy_host != ""}${var.default_server_host_override_proxy_host}%{else}$http_host%{endif};
       proxy_set_header X-Original-URI $request_uri;
       proxy_http_version 1.1;
       proxy_pass ${var.default_server_host};

       ${var.openresty_index_block}
    }

    #Help Center Search
    location =/wp-admin/admin-ajax.php {
        proxy_pass ${var.default_server_host};
        proxy_set_header Host %{if var.default_server_host_override_proxy_host != ""}${var.default_server_host_override_proxy_host}%{else}$http_host%{endif};
        proxy_set_header X-Original-URI $request_uri;
    }

    #Disable path
    location  ~* ^/(wp-admin|wp-login.php|readme.html|xmlrpc.php){
        deny all;
    }

    location =/ {
      proxy_set_header Host %{if var.default_server_host_override_proxy_host != ""}${var.default_server_host_override_proxy_host}%{else}$http_host%{endif};
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_cache off;
      set $cms 0;
      ${var.openresty_index_block}

      if ($uri ~* wp-login.php$){
           proxy_pass ${var.default_server_host};
           set $cms 1;
      }
      if ($args ~* home=1){
           proxy_pass ${var.default_server_host};
           set $cms 1;
      }

      if ($http_referer ~* "wp-admin"){
           proxy_pass ${var.default_server_host};
           set $cms 1;
      }

      if ($http_user_agent ~* "qihoobot|Baiduspider|Googlebot|Googlebot-Mobile|Googlebot-Image|Mediapartners-Google|Adsbot-Google|Feedfetjauntycher-Google|Yahoo! Slurp|Yahoo! Slurp China|YoudaoBot|Sosospider|Sogouspider|Sogou web spider|MSNBot|ia_archiver|Tomato Bot"){
           proxy_pass ${var.default_server_host};
           set $cms 1;
      }

      if ($cms = 0){
           %{if var.default_server_host_override_proxy_host != ""~}
           proxy_pass ${var.default_server_host};
           %{else}
           proxy_pass   http://web-server;
           add_header  Content-Type    text/html;
           add_header 'Cache-Control' 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
           expires off;
           %{endif~}
        }
    }

    #Allow embedded routes
    location ~* ^/(login|share|404|widget-stage|embed) {
      proxy_set_header Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      proxy_connect_timeout 300;
      proxy_http_version 1.1;
      proxy_set_header Connection "";
      chunked_transfer_encoding off;
      proxy_pass   http://web-server;
      add_header 'Cache-Control' 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
    }

    #Allow embedded routes and cache
    location ~* ^/(custom|file)/ {
      proxy_set_header Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      proxy_connect_timeout 300;
      proxy_pass   http://web-server;
      add_header 'Cache-Control' 'public, max-age=2592000';
      proxy_redirect off;
      proxy_cache cache_one;
      proxy_cache_valid 200 302 1h;
      proxy_cache_valid 301 1d;
      proxy_cache_valid any 1m;
      expires 7d;
    }

    #Prevent external sites from embedding routes
    location ~* ^/(space|user|invite|template|workbench|org|management|notify) {
      proxy_set_header Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      proxy_connect_timeout 300;
      proxy_http_version 1.1;
      proxy_set_header Connection "";
      chunked_transfer_encoding off;
      proxy_pass   http://web-server;
      add_header 'Cache-Control' 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
      add_header 'X-Frame-Options' 'SAMEORIGIN';
    }

    location /_next {
        proxy_pass   http://web-server;
        proxy_connect_timeout 300;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Static resources (config_map_kong will overwrite this in saas environment)
    location /web_build {
      proxy_set_header Host $http_host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_pass http://web-server/web_build;
      add_header 'Cache-Control' 'public, max-age=2592000';
      proxy_redirect off;
      proxy_cache cache_one;
      proxy_cache_valid 200 302 1h;
      proxy_cache_valid 301 1d;
      proxy_cache_valid any 1m;
      expires 7d;
    }
    EOT

    "lbs-amap.conf" = <<-EOT
    %{if var.lbs_amap_secret != ""~}
    location /_AMapService/v4/map/styles {
        set $args "$args&jscode=${var.lbs_amap_secret}";
        proxy_pass https://webapi.amap.com/v4/map/styles;
    }

    location /_AMapService/v3/vectormap {
        set $args "$args&jscode=${var.lbs_amap_secret}";
        proxy_pass https://fmap01.amap.com/v3/vectormap;
    }

    location /_AMapService/ {
        set $args "$args&jscode=${var.lbs_amap_secret}";
        proxy_pass https://restapi.amap.com/;
    }
    %{else}
       #
    %{endif~}

    EOT

    #Robots
    "disable_robots.txt" = <<-EOT
    User-agent: *
    Disallow: /
    EOT
    "enable_robots.txt"  = <<-EOT
    User-agent: *
    Disallow: /wp-admin/
    Allow: /wp-admin/admin-ajax.php
    EOT

    "static-proxy.conf" = <<-EOT
    %{if var.developers_redirect_url != ""~}
    location ^~ /developers {
        rewrite ^/developers/?(.*)$ ${var.developers_redirect_url}/$1 permanent;
    }
    %{endif~}
    location /pricing {
        proxy_pass   ${var.pricing_host};
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    # pricing nextjs static resources
    location /pricing/_next {
        proxy_pass   ${var.pricing_host}/_next;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        add_header 'Cache-Control' 'public, max-age=2592000';
        proxy_redirect off;
        proxy_cache cache_one;
        proxy_cache_valid 200 302 1h;
        proxy_cache_valid 301 1d;
        proxy_cache_valid any 1m;
        expires 7d;
    }
    EOT

    "imageproxy-server.conf" = <<-EOT
    location /${var.public_assets_bucket} {
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      # enable cache
      proxy_cache cache_one;
      proxy_cache_valid 200 302 3h;
      proxy_cache_valid any 1m;

      proxy_connect_timeout 300;
      chunked_transfer_encoding off;
      proxy_pass   http://imageproxy-server/image/${var.public_assets_bucket}/;
      if ( $args !~* ^imageView ){
          proxy_pass   ${var.minio_host};
      }

      if ( $request_method = PUT ){
         proxy_pass ${var.minio_host};
      }

    }
    location ~* ^/(minio) {
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      proxy_connect_timeout 300;
      proxy_http_version 1.1;
      proxy_set_header Connection "";
      chunked_transfer_encoding off;
      proxy_pass   ${var.minio_host};
    }


    location /oss {
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      proxy_connect_timeout 300;
      proxy_http_version 1.1;
      proxy_set_header Connection "";
      chunked_transfer_encoding off;
      proxy_pass ${var.minio_host}/${var.public_assets_bucket}/;
    }

    location =/${var.public_assets_bucket} {
       return 403;
    }
    EOT

    # Empty config, used to populate the config by default
    "blank.config" = ""

    "openresty_extra_config.conf" = var.openresty_extra_config

  }
}

