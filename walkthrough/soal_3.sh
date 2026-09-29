#!/bin/bash

# Mendapatkan hostname node saat ini
CURRENT_HOST=$(hostname)

# Konfigurasi resolver awal untuk semua host
echo "Mengatur nameserver ke 192.168.122.1 pada /etc/resolv.conf..."
echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Pengujian spesifik berdasarkan node
case "$CURRENT_HOST" in
    "prab")
        echo "Melakukan pengujian routing internal ke alpha (192.213.2.2) dan internet (google.com)..."
        ping -c 3 192.213.2.2
        ping -c 3 google.com
        ;;
    *)
        echo "Resolver untuk host '$CURRENT_HOST' berhasil diatur."
        ;;
esac