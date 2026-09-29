#!/bin/bash

# Mendapatkan hostname node saat ini
CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "rootkit")
        echo "Mengonfigurasi NAT dan IP Forwarding pada rootkit (Router)..."
        apt update
        apt install iptables -y
        iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.213.0.0/16
        echo 1 > /proc/sys/net/ipv4/ip_forward
        echo "Konfigurasi NAT pada rootkit berhasil diterapkan."
        ;;

    "prab")
        echo "Melakukan pengujian koneksi internet (ping ke 8.8.8.8) dari prab..."
        ping -c 4 8.8.8.8
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak dikenali dalam konfigurasi ini."
        exit 1
        ;;
esac