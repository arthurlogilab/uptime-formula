
nginx:
  pkg:
    - installed
  service.running: 
    - watch: 
        - file: /etc/nginx/sites-enabled/default

/etc/nginx/sites-enabled/default:
  file.managed:
    - source: salt://uptime/nginx_config
