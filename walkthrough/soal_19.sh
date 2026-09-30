#!/bin/bash
# Soal 19 - CNAME ke domain eksternal
#   outbound.k04.com  CNAME  http.badssl.com.

CURRENT_HOST=$(hostname)
ZONE_FILE=/etc/bind/k04/k04.com

case "$CURRENT_HOST" in
    "prab")
        echo "Menambahkan CNAME outbound pada prab..."
        # Titik di akhir http.badssl.com. wajib (nama domain absolut)
        grep -q "^outbound" "$ZONE_FILE" || \
            echo "outbound    IN      CNAME   http.badssl.com." >> "$ZONE_FILE"

        OLD=$(grep -m1 -oE '[0-9]{10}' "$ZONE_FILE")
        NEW=$((OLD + 1))
        sed -i "s/$OLD/$NEW/" "$ZONE_FILE"
        echo "Serial SOA: $OLD -> $NEW"

        named-checkzone k04.com "$ZONE_FILE" && service bind9 restart
        grep outbound "$ZONE_FILE"
        ;;

    "alpha")
        echo "=== 1. dig outbound.k04.com (bukti CNAME) ==="
        dig outbound.k04.com +noall +answer
        echo ""
        echo "=== 2. Tanpa Host header ==="
        curl -s http://outbound.k04.com | head -n 8
        echo ""
        echo "=== 3. Dengan Host: http.badssl.com (lewat outbound.k04.com) ==="
        curl -sv -H "Host: http.badssl.com" http://outbound.k04.com 2>&1 | grep -E "Connected to|> Host:"
        curl -s -H "Host: http.badssl.com" http://outbound.k04.com | head -n 15
        echo ""
        echo "=== 4. Perbandingan isi dengan http.badssl.com ==="
        if [ "$(curl -s -H 'Host: http.badssl.com' http://outbound.k04.com | md5sum)" = "$(curl -s http://http.badssl.com | md5sum)" ]; then
            echo "ISI SAMA"
        else
            echo "ISI BERBEDA"
        fi
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak memerlukan aksi khusus pada skrip ini."
        ;;
esac
