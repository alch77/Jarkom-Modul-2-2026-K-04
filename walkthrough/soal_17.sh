#!/bin/bash
# Soal 17 - TXT record untuk klien sayap kiri & kanan
#   alpha/beta/gamma/delta/epsilon.k04.com  TXT  "<nama host>"

CURRENT_HOST=$(hostname)
ZONE_FILE=/etc/bind/k04/k04.com

case "$CURRENT_HOST" in
    "prab")
        echo "Menambahkan TXT record pada prab..."
        for h in alpha beta gamma delta epsilon; do
            grep -qE "^$h[[:space:]]+IN[[:space:]]+TXT" "$ZONE_FILE" || \
                printf '%-12s IN      TXT     "%s"\n' "$h" "$h" >> "$ZONE_FILE"
        done

        # Naikkan serial SOA +1 agar tedd menyalin zona terbaru
        OLD=$(grep -m1 -oE '[0-9]{10}' "$ZONE_FILE")
        NEW=$((OLD + 1))
        sed -i "s/$OLD/$NEW/" "$ZONE_FILE"
        echo "Serial SOA: $OLD -> $NEW"

        named-checkzone k04.com "$ZONE_FILE" && service bind9 restart
        grep TXT "$ZONE_FILE"
        ;;

    "alpha"|"beta"|"gamma"|"delta"|"epsilon")
        for h in alpha beta gamma delta epsilon; do
            echo "$h.k04.com -> prab: $(dig @192.213.1.2 $h.k04.com TXT +short) | tedd: $(dig @192.213.1.3 $h.k04.com TXT +short)"
        done
        echo ""
        echo "Serial prab: $(dig @192.213.1.2 k04.com SOA +short | awk '{print $3}')"
        echo "Serial tedd: $(dig @192.213.1.3 k04.com SOA +short | awk '{print $3}')"
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak memerlukan aksi khusus pada skrip ini."
        ;;
esac
