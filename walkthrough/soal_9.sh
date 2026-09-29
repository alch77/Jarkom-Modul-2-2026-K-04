#!/bin/bash

# Mendapatkan hostname node saat ini
CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "obladi")
        echo "Mengonfigurasi Apache Web Server pada obladi..."
        apt update
        apt install apache2 -y

        mkdir -p /var/www/arsip/

        cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerName obladi.k04.com
    ServerAdmin webmaster@obladi.k04.com
    DocumentRoot /var/www/arsip

    <Directory /var/www/arsip>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF

        service apache2 restart
        echo "Konfigurasi Apache pada obladi selesai."
        ;;

    "desmond")
        echo "Mengonfigurasi Apache Web Server pada desmond..."
        apt update
        apt install apache2 -y

        mkdir -p /var/www/arsip/

        cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerName desmond.k04.com
    ServerAdmin webmaster@desmond.k04.com
    DocumentRoot /var/www/arsip

    <Directory /var/www/arsip>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF

        service apache2 restart
        echo "Konfigurasi Apache pada desmond selesai."
        ;;

    "alpha")
        echo "Melakukan pengujian akses web server dari alpha..."
        
        echo "=== Menguji http://obladi.k04.com ==="
        curl -I http://obladi.k04.com
        
        echo "=== Menguji http://desmond.k04.com ==="
        curl -I http://desmond.k04.com
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak memerlukan aksi khusus pada skrip ini."
        ;;
esac