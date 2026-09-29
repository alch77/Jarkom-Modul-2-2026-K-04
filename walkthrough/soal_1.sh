#!/bin/bash

# Mendapatkan hostname node saat ini
CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "rootkit")
        echo "Mengonfigurasi jaringan untuk rootkit (Router)..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.213.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.213.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.213.3.1
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 192.213.4.1
	netmask 255.255.255.0

auto eth5
iface eth5 inet static
	address 192.213.5.1
	netmask 255.255.255.0
EOF
        ;;

    "prab")
        echo "Mengonfigurasi jaringan untuk prab..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.1.2
	netmask 255.255.255.0
	gateway 192.213.1.1
EOF
        ;;

    "tedd")
        echo "Mengonfigurasi jaringan untuk tedd..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.1.3
	netmask 255.255.255.0
	gateway 192.213.1.1
EOF
        ;;

    "obladi")
        echo "Mengonfigurasi jaringan untuk obladi..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.1.4
	netmask 255.255.255.0
	gateway 192.213.1.1
EOF
        ;;

    "desmond")
        echo "Mengonfigurasi jaringan untuk desmond..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.1.5
	netmask 255.255.255.0
	gateway 192.213.1.1
EOF
        ;;

    "oblada")
        echo "Mengonfigurasi jaringan untuk oblada..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.1.6
	netmask 255.255.255.0
	gateway 192.213.1.1
EOF
        ;;

    "molly")
        echo "Mengonfigurasi jaringan untuk molly..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.1.7
	netmask 255.255.255.0
	gateway 192.213.1.1
EOF
        ;;

    "alpha")
        echo "Mengonfigurasi jaringan untuk alpha..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.2.2
	netmask 255.255.255.0
	gateway 192.213.2.1
EOF
        ;;

    "beta")
        echo "Mengonfigurasi jaringan untuk beta..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.2.3
	netmask 255.255.255.0
	gateway 192.213.2.1
EOF
        ;;

    "gamma")
        echo "Mengonfigurasi jaringan untuk gamma..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.2.4
	netmask 255.255.255.0
	gateway 192.213.2.1
EOF
        ;;

    "delta")
        echo "Mengonfigurasi jaringan untuk delta..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.3.2
	netmask 255.255.255.0
	gateway 192.213.3.1
EOF
        ;;

    "epsilon")
        echo "Mengonfigurasi jaringan untuk epsilon..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.3.3
	netmask 255.255.255.0
	gateway 192.213.3.1
EOF
        ;;

    "abbey")
        echo "Mengonfigurasi jaringan untuk abbey..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.4.2
	netmask 255.255.255.0
	gateway 192.213.4.1
EOF
        ;;

    "penny")
        echo "Mengonfigurasi jaringan untuk penny..."
        cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.213.5.2
	netmask 255.255.255.0
	gateway 192.213.5.1
EOF
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak dikenali dalam konfigurasi ini."
        exit 1
        ;;
esac

echo "Konfigurasi selesai. Silakan restart layanan networking atau reboot node jika diperlukan."