#!/bin/bash
# Soal 11 - Reverse proxy + load balancing
#   penny (Apache) -> vault (obladi 192.213.1.4, desmond 192.213.1.5)
#   abbey (Nginx)  -> core  (oblada 192.213.1.6, molly 192.213.1.7)
#   Header yang diteruskan: Host dan X-Real-IP

CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "obladi"|"desmond")
        echo "Menyiapkan penanda backend dan log header pada $CURRENT_HOST..."
        echo "Dilayani oleh: $CURRENT_HOST" > /var/www/arsip/whoami.txt

        cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerName $CURRENT_HOST.k04.com
    DocumentRoot /var/www/arsip

    <Directory /var/www/arsip>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
    CustomLog /var/log/apache2/header.log "%t dari=%h Host=%{Host}i X-Real-IP=%{X-Real-IP}i \"%r\""
</VirtualHost>
EOF
        service apache2 restart
        ;;

    "oblada"|"molly")
        echo "Membuat halaman /headers pada $CURRENT_HOST..."
        cat <<'EOF' > /var/www/html/headers.php
<?php
echo "Backend      : " . gethostname() . "\n";
echo "Host header  : " . ($_SERVER['HTTP_HOST'] ?? '-') . "\n";
echo "X-Real-IP    : " . ($_SERVER['HTTP_X_REAL_IP'] ?? '-') . "\n";
echo "REMOTE_ADDR  : " . ($_SERVER['REMOTE_ADDR'] ?? '-') . "\n";
EOF
        ;;

    "penny")
        echo "Mengonfigurasi Apache reverse proxy pada penny..."
        printf "nameserver 192.213.1.2\nnameserver 192.213.1.3\nnameserver 192.168.122.1\n" > /etc/resolv.conf
        apt update
        apt install apache2 curl -y
        a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers
        mkdir -p /etc/apache2/penny-extra

        cat <<'EOF' > /etc/apache2/sites-available/www.conf
<VirtualHost *:80>
    ServerName www.k04.com

    ProxyPreserveHost On
    RequestHeader set X-Real-IP "expr=%{REMOTE_ADDR}"

    <Proxy "balancer://vault">
        BalancerMember "http://192.213.1.4"
        BalancerMember "http://192.213.1.5"
    </Proxy>

    IncludeOptional /etc/apache2/penny-extra/*.conf

    ProxyPass        "/" "balancer://vault/"
    ProxyPassReverse "/" "balancer://vault/"

    ErrorLog  ${APACHE_LOG_DIR}/www_error.log
    CustomLog ${APACHE_LOG_DIR}/www_access.log combined
</VirtualHost>
EOF
        a2dissite 000-default
        a2ensite www
        apache2ctl configtest && service apache2 restart
        ;;

    "abbey")
        echo "Mengonfigurasi Nginx reverse proxy pada abbey..."
        printf "nameserver 192.213.1.2\nnameserver 192.213.1.3\nnameserver 192.168.122.1\n" > /etc/resolv.conf
        apt update
        apt install nginx curl -y
        mkdir -p /etc/nginx/abbey-extra

        cat <<'EOF' > /etc/nginx/sites-available/static
upstream core_backend {
    zone core_backend 64k;
    server 192.213.1.6;   # oblada
    server 192.213.1.7;   # molly
}

server {
    listen 80 default_server;
    server_name static.k04.com;

    include /etc/nginx/abbey-extra/*.conf;

    location / {
        proxy_pass http://core_backend;
        proxy_set_header Host            $host;
        proxy_set_header X-Real-IP       $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF
        rm -f /etc/nginx/sites-enabled/default
        ln -sf /etc/nginx/sites-available/static /etc/nginx/sites-enabled/static
        nginx -t && service nginx restart
        ;;

    "alpha")
        echo "=== penny -> vault ==="
        for i in 1 2 3 4; do curl -s http://www.k04.com/whoami.txt; done
        echo ""
        echo "=== abbey -> core ==="
        for i in 1 2 3 4; do curl -s http://static.k04.com/headers; echo "---"; done
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak memerlukan aksi khusus pada skrip ini."
        ;;
esac
