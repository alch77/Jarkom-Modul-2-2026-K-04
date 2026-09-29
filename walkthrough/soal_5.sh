#!/bin/bash

# Mendapatkan hostname node saat ini
CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "prab")
        echo "Menambahkan record DNS ke area k04.com pada Master DNS (prab)..."
        
        # Menambahkan record A untuk node-node lainnya
        cat <<EOF >> /etc/bind/k04/k04.com
alpha       IN      A       192.213.2.2
beta        IN      A       192.213.2.3
gamma       IN      A       192.213.2.4
delta       IN      A       192.213.3.2
epsilon     IN      A       192.213.3.3
abbey       IN      A       192.213.4.2
penny       IN      A       192.213.5.2
obladi      IN      A       192.213.1.4
desmond     IN      A       192.213.1.5
oblada      IN      A       192.213.1.6
molly       IN      A       192.213.1.7
EOF

        echo "Me-restart layanan bind9..."
        service bind9 restart
        echo "Konfigurasi record DNS pada prab berhasil diperbarui."
        ;;

    "alpha")
        echo "Melakukan pengujian koneksi (ping) menggunakan FQDN dari alpha..."
        ping -c 3 beta.k04.com
        ping -c 3 obladi.k04.com
        ping -c 3 epsilon.k04.com
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak memerlukan aksi khusus pada skrip ini."
        ;;
esac