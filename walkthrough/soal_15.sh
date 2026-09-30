#!/bin/bash
# Soal 15 - Jalur khusus yang berdiri sendiri
#   penny : /eternal -> /var/www/eternal (PHP dirender lewat PHP-FPM)
#   abbey : /orion   -> /var/www/orion   (murni statis, tanpa PHP)

CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "penny")
        echo "Mengonfigurasi /eternal dengan PHP-FPM pada penny..."
        apt install php-fpm -y

        PHPFPM=$(ls /etc/init.d | grep -E '^php[0-9.]+-fpm$' | sort -V | tail -n 1)
        echo "Service PHP-FPM terdeteksi: $PHPFPM"

        a2enmod proxy_fcgi setenvif
        a2enconf $PHPFPM

        mkdir -p /var/www/eternal
        cat <<'EOF' > /var/www/eternal/index.php
<?php
echo "<h1>Eternal - dirender oleh PHP di " . gethostname() . "</h1>";
echo "<p>Versi PHP: " . phpversion() . "</p>";
echo "<p>Waktu server: " . date('Y-m-d H:i:s') . "</p>";
EOF

        cat <<'EOF' > /etc/apache2/penny-extra/eternal.conf
ProxyPass /eternal !
Alias /eternal /var/www/eternal

<Directory /var/www/eternal>
    DirectoryIndex index.php
    Require all granted
</Directory>
EOF

        service $PHPFPM restart
        apache2ctl configtest && service apache2 restart
        ;;

    "abbey")
        echo "Mengonfigurasi /orion statis pada abbey..."
        mkdir -p /var/www/orion
        cat <<'EOF' > /var/www/orion/index.html
<h1>Orion - halaman statis dari abbey</h1>
<p>Tidak ada PHP di sini.</p>
EOF

        cat <<'EOF' > /etc/nginx/abbey-extra/orion.conf
location /orion {
    alias /var/www/orion;
    index index.html;
}
EOF

        nginx -t && service nginx restart
        ;;

    "alpha")
        echo "=== www.k04.com/eternal/ (penny, PHP dirender) ==="
        curl -s http://www.k04.com/eternal/
        echo ""
        echo ""
        echo "=== static.k04.com/orion/ (abbey, statis) ==="
        curl -s http://static.k04.com/orion/
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak memerlukan aksi khusus pada skrip ini."
        ;;
esac
