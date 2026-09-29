#!/bin/bash

# Mendapatkan hostname node saat ini
CURRENT_HOST=$(hostname)

# Konfigurasi resolver untuk semua host klien (selain prab dan tedd, atau bisa diterapkan ke semua host jika diinginkan)
update_resolv_conf() {
    echo "Mengatur /etc/resolv.conf dengan nameserver master, slave, dan upstream..."
    cat <<EOF > /etc/resolv.conf
nameserver 192.213.1.2
nameserver 192.213.1.3
nameserver 192.168.122.1
EOF
}

case "$CURRENT_HOST" in
    "prab")
        echo "Mengonfigurasi Master DNS (prab)..."
        apt update
        apt install bind9 -y
        ln -s /etc/init.d/named /etc/init.d/bind9

        cat <<EOF > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    auth-nxdomain no;
    listen-on { any; };
    listen-on-v6 { any; };
};
EOF

        mkdir -p /etc/bind/k04 && cat <<EOF > /etc/bind/k04/k04.com
\$TTL    604800          ; Waktu cache default (detik)
@       IN      SOA     prab.k04.com. root.k04.com. (
                        2026092801 ; Serial (format YYYYMMDDXX)
                        604800     ; Refresh (1 minggu)
                        86400      ; Retry (1 hari)
                        2419200    ; Expire (4 minggu)
                        604800 )   ; Negative Cache TTL

@       IN      NS      prab.k04.com.
@       IN      NS      tedd.k04.com.

prab    IN      A       192.213.1.2
tedd    IN      A       192.213.1.3

@       IN      A       192.213.5.2
EOF

        cat <<EOF > /etc/bind/named.conf.local
zone "k04.com" {
    type master;
    file "/etc/bind/k04/k04.com";
    allow-transfer { 192.213.1.3; };
    notify yes;
};
EOF

        service bind9 restart
        update_resolv_conf

        echo "Melakukan pengujian dig pada prab..."
        dig @localhost k04.com
        ;;

    "tedd")
        echo "Mengonfigurasi Slave DNS (tedd)..."
        apt update
        apt install bind9 -y
        ln -s /etc/init.d/named /etc/init.d/bind9

        cat <<EOF > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    auth-nxdomain no;
    listen-on { any; };
    listen-on-v6 { any; };
};
EOF

        mkdir -p /var/lib/bind/k04 && chown bind:bind /var/lib/bind/k04 && cat <<EOF > /etc/bind/named.conf.local
zone "k04.com" {
    type slave;
    masters { 192.213.1.2; };
    file "/var/lib/bind/k04/k04.com";
};
EOF

        service bind9 restart
        update_resolv_conf
        ;;

    "alpha")
        echo "Mengonfigurasi resolver dan melakukan pengujian pada alpha..."
        update_resolv_conf

        echo "Menjalankan uji dig..."
        dig k04.com +short
        dig prab.k04.com +short
        dig tedd.k04.com +short
        ;;

    *)
        echo "Mengonfigurasi resolver untuk host $CURRENT_HOST..."
        update_resolv_conf
        ;;
esac

echo "Konfigurasi DNS selesai pada node $CURRENT_HOST."