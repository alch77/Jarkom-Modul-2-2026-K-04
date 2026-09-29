#!/bin/bash

# Mendapatkan hostname node saat ini
CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "prab")
        echo "Menambahkan record Vault, Core, dan CNAME ke area k04.com pada Master DNS (prab)..."
        
        cat <<EOF >> /etc/bind/k04/k04.com
vault       IN      A       192.213.1.4
vault       IN      A       192.213.1.5
core        IN      A       192.213.1.6
core        IN      A       192.213.1.7

www         IN      CNAME   penny.k04.com.
static      IN      CNAME   abbey.k04.com.
EOF

        echo "Me-restart layanan bind9..."
        service bind9 restart
        echo "Konfigurasi record DNS tambahan pada prab berhasil diterapkan."
        ;;

    "alpha"|"delta")
        echo "Melakukan pengujian DNS menggunakan dig dari node $CURRENT_HOST..."
        
        echo "=== Query www.k04.com ==="
        dig www.k04.com +short
        
        echo "=== Query static.k04.com ==="
        dig static.k04.com +short
        
        echo "=== Query vault.k04.com ==="
        dig vault.k04.com +short
        
        echo "=== Query core.k04.com ==="
        dig core.k04.com +short
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak memerlukan aksi khusus pada skrip ini."
        ;;
esac