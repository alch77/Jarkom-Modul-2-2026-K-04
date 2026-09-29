#!/bin/bash

# Mendapatkan hostname node saat ini
CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "prab")
        echo "Mengonfigurasi Reverse DNS (PTR) Master zones pada prab..."
        
        # Menambahkan konfigurasi zone reverse ke named.conf.local
        cat <<EOF >> /etc/bind/named.conf.local

zone "1.213.192.in-addr.arpa" {
    type master;
    file "/etc/bind/k04/1.213.192.in-addr.arpa";
    allow-transfer { 192.213.1.3; };
};

zone "4.213.192.in-addr.arpa" {
    type master;
    file "/etc/bind/k04/4.213.192.in-addr.arpa";
    allow-transfer { 192.213.1.3; };
};

zone "5.213.192.in-addr.arpa" {
    type master;
    file "/etc/bind/k04/5.213.192.in-addr.arpa";
    allow-transfer { 192.213.1.3; };
};
EOF

        # Membuat file zone untuk 1.213.192.in-addr.arpa
        cat <<EOF > /etc/bind/k04/1.213.192.in-addr.arpa
\$TTL    604800
@       IN      SOA     prab.k04.com. root.k04.com. (
                        2026092801 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL

@       IN      NS      prab.k04.com.
@       IN      NS      tedd.k04.com.

2       IN      PTR     prab.k04.com.
3       IN      PTR     tedd.k04.com.
4       IN      PTR     obladi.k04.com.
5       IN      PTR     desmond.k04.com.
6       IN      PTR     oblada.k04.com.
7       IN      PTR     molly.k04.com.
EOF

        # Membuat file zone untuk 4.213.192.in-addr.arpa
        cat <<EOF > /etc/bind/k04/4.213.192.in-addr.arpa
\$TTL    604800
@       IN      SOA     prab.k04.com. root.k04.com. (
                        2026092801 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL

@       IN      NS      prab.k04.com.
@       IN      NS      tedd.k04.com.

2       IN      PTR     abbey.k04.com.
EOF

        # Membuat file zone untuk 5.213.192.in-addr.arpa
        cat <<EOF > /etc/bind/k04/5.213.192.in-addr.arpa
\$TTL    604800
@       IN      SOA     prab.k04.com. root.k04.com. (
                        2026092801 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL

@       IN      NS      prab.k04.com.
@       IN      NS      tedd.k04.com.

2       IN      PTR     penny.k04.com.
EOF

        echo "Me-restart layanan bind9 pada prab..."
        service bind9 restart
        echo "Konfigurasi Master Reverse DNS selesai."
        ;;

    "tedd")
        echo "Mengonfigurasi Reverse DNS (PTR) Slave zones pada tedd..."
        
        cat <<EOF >> /etc/bind/named.conf.local

zone "1.213.192.in-addr.arpa" {
    type slave;
    masters { 192.213.1.2; };
    file "/var/lib/bind/k04/1.213.192.in-addr.arpa";
};

zone "4.213.192.in-addr.arpa" {
    type slave;
    masters { 192.213.1.2; };
    file "/var/lib/bind/k04/4.213.192.in-addr.arpa";
};

zone "5.213.192.in-addr.arpa" {
    type slave;
    masters { 192.213.1.2; };
    file "/var/lib/bind/k04/5.213.192.in-addr.arpa";
};
EOF

        echo "Me-restart layanan bind9 pada tedd..."
        service bind9 restart
        echo "Konfigurasi Slave Reverse DNS selesai."
        ;;

    "alpha")
        echo "Melakukan pengujian Reverse DNS (PTR) dari alpha..."
        
        echo "=== Uji PTR 192.213.4.2 ==="
        host -t ptr 192.213.4.2
        
        echo "=== Uji PTR 192.213.5.2 ==="
        host -t ptr 192.213.5.2
        
        echo "=== Uji PTR 192.213.1.4 ==="
        host -t ptr 192.213.1.4
        
        echo "=== Uji PTR 192.213.1.6 ==="
        host -t ptr 192.213.1.6
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak memerlukan aksi khusus pada skrip ini."
        ;;
esac