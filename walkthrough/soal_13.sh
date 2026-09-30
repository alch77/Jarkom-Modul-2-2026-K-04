#!/bin/bash
# Soal 13 - Redirect ke nama kanonik
#   IP penny / penny.k04.com -> 301 (permanen)  -> http://www.k04.com
#   IP abbey / abbey.k04.com -> 302 (sementara) -> http://static.k04.com

CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "penny")
        echo "Mengonfigurasi redirect 301 pada penny..."
        cat <<'EOF' > /etc/apache2/sites-available/000-canonical.conf
<VirtualHost *:80>
    ServerName penny.k04.com
    ServerAlias 192.213.5.2 k04.com

    Redirect permanent / http://www.k04.com/
</VirtualHost>
EOF
        a2ensite 000-canonical
        apache2ctl configtest && service apache2 restart
        ;;

    "abbey")
        echo "Mengonfigurasi redirect 302 pada abbey..."
        cat <<'EOF' > /etc/nginx/sites-available/canonical
server {
    listen 80;
    server_name abbey.k04.com 192.213.4.2;

    return 302 http://static.k04.com$request_uri;
}
EOF
        ln -sf /etc/nginx/sites-available/canonical /etc/nginx/sites-enabled/canonical
        nginx -t && service nginx restart
        ;;

    "alpha")
        for url in http://192.213.5.2/ http://penny.k04.com/ http://192.213.4.2/ http://abbey.k04.com/; do
            echo "=== $url ==="
            curl -s -I "$url" | grep -iE "^HTTP|^Location"
        done
        echo "=== Cek www & static tetap normal ==="
        curl -s -o /dev/null -w "www    -> HTTP %{http_code}\n" http://www.k04.com/whoami.txt
        curl -s -o /dev/null -w "static -> HTTP %{http_code}\n" http://static.k04.com/headers
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak memerlukan aksi khusus pada skrip ini."
        ;;
esac
