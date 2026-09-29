#!/bin/bash

# Mendapatkan hostname node saat ini
CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "oblada")
        echo "Mengonfigurasi Nginx dan PHP-FPM pada oblada..."
        apt update
        apt install nginx php-fpm -y

        mkdir -p /var/www/html

        cat <<EOF > /var/www/html/index.php
<?php
echo "<h1>Selamat Datang di Beranda Core (Oblada)</h1>";
echo "<p>Ini adalah halaman utama web dinamis.</p>";
?>
EOF

        cat <<EOF > /var/www/html/profil.php
<?php
echo "<h1>Halaman Profil Oblada</h1>";
echo "<p>Ini adalah halaman profil resmi dari area core (oblada).</p>";
?>
EOF

        cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm;

    server_name oblada.k04.com core.k04.com;

    # Aturan URL Rewrite agar /profil bisa diakses tanpa .php
    location / {
        try_files \$uri \$uri/ @rewrite;
    }

    location @rewrite {
        rewrite ^/(.*)\$ /\$1.php last;
    }

    # Penanganan file PHP menggunakan PHP-FPM Unix Socket
    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

        service php8.4-fpm restart
        service nginx restart
        echo "Konfigurasi Nginx dan PHP-FPM pada oblada selesai."
        ;;

    "molly")
        echo "Mengonfigurasi Nginx dan PHP-FPM pada molly..."
        apt update
        apt install nginx php-fpm -y

        mkdir -p /var/www/html

        cat <<EOF > /var/www/html/index.php
<?php
echo "<h1>Selamat Datang di Beranda Core (Molly)</h1>";
echo "<p>Ini adalah halaman utama web dinamis.</p>";
?>
EOF

        cat <<EOF > /var/www/html/profil.php
<?php
echo "<h1>Halaman Profil Molly</h1>";
echo "<p>Ini adalah halaman profil resmi dari area core (molly).</p>";
?>
EOF

        cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm;

    server_name molly.k04.com core.k04.com;

    # Aturan URL Rewrite agar /profil bisa diakses tanpa .php
    location / {
        try_files \$uri \$uri/ @rewrite;
    }

    location @rewrite {
        rewrite ^/(.*)\$ /\$1.php last;
    }

    # Penanganan file PHP menggunakan PHP-FPM Unix Socket
    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

        service php8.4-fpm restart
        service nginx restart
        echo "Konfigurasi Nginx dan PHP-FPM pada molly selesai."
        ;;

    "alpha")
        echo "Melakukan pengujian akses web server dari alpha..."
        
        echo "=== Menguji http://oblada.k04.com/ ==="
        curl -s http://oblada.k04.com/
        echo -e "\n"

        echo "=== Menguji http://molly.k04.com/ ==="
        curl -s http://molly.k04.com/
        echo -e "\n"

        echo "=== Menguji http://oblada.k04.com/profil ==="
        curl -s http://oblada.k04.com/profil
        echo -e "\n"

        echo "=== Menguji http://molly.k04.com/profil ==="
        curl -s http://molly.k04.com/profil
        echo -e "\n"
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak memerlukan aksi khusus pada skrip ini."
        ;;
esac