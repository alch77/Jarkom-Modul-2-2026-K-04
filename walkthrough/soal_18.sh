#!/bin/bash
# Soal 18 - Uji TTL & cache DNS (3 fase)
#   prab  : bash soal_18.sh ttl      -> set TTL abbey 15 detik (IP masih asli)
#   prab  : bash soal_18.sh ubah     -> ganti IP abbey ke IP fiktif
#   prab  : bash soal_18.sh kembali  -> kembalikan IP & TTL abbey ke normal
#   alpha : bash soal_18.sh setup    -> pasang dnsmasq sebagai cache DNS lokal
#   alpha : bash soal_18.sh pantau   -> pantau jawaban DNS abbey tiap 2 detik

CURRENT_HOST=$(hostname)
ZONE_FILE=/etc/bind/k04/k04.com
OLD_IP=192.213.4.2
FAKE_IP=172.30.18.18
STEP=$1

bump_serial() {
    OLD=$(grep -m1 -oE '[0-9]{10}' "$ZONE_FILE")
    NEW=$((OLD + 1))
    sed -i "s/$OLD/$NEW/" "$ZONE_FILE"
    echo "Serial SOA: $OLD -> $NEW"
}

reload_dns() {
    named-checkzone k04.com "$ZONE_FILE" && (rndc reload k04.com || service bind9 restart)
    sleep 2
    echo "Serial prab   : $(dig @192.213.1.2 k04.com SOA +short | awk '{print $3}')"
    echo "Serial tedd   : $(dig @192.213.1.3 k04.com SOA +short | awk '{print $3}')"
    echo "abbey di prab : $(dig @192.213.1.2 abbey.k04.com +noall +answer)"
    echo "abbey di tedd : $(dig @192.213.1.3 abbey.k04.com +noall +answer)"
}

set_abbey() {
    sed -i "s/^abbey[[:space:]].*$/$1/" "$ZONE_FILE"
    echo "Record baru   : $(grep '^abbey' $ZONE_FILE)"
}

case "$CURRENT_HOST:$STEP" in
    "prab:ttl")
        set_abbey "abbey       15      IN      A       $OLD_IP"
        bump_serial; reload_dns ;;
    "prab:ubah")
        set_abbey "abbey       15      IN      A       $FAKE_IP"
        bump_serial; reload_dns ;;
    "prab:kembali")
        set_abbey "abbey               IN      A       $OLD_IP"
        bump_serial; reload_dns ;;
    "alpha:setup")
        apt install dnsmasq -y
        service dnsmasq stop 2>/dev/null; pkill dnsmasq; sleep 1
        dnsmasq --no-resolv --no-hosts --server=192.213.1.2 \
                --listen-address=127.0.0.1 --bind-interfaces --cache-size=1000
        echo "dnsmasq aktif sebagai cache DNS di 127.0.0.1" ;;
    "alpha:pantau")
        for i in $(seq 1 25); do
            CACHE=$(dig @127.0.0.1 abbey.k04.com +noall +answer | awk '{print "IP=" $5 " sisaTTL=" $2}')
            AUTH=$(dig @192.213.1.2 abbey.k04.com +short)
            echo "$(date +%H:%M:%S) | via cache (alpha): $CACHE | langsung ke prab: $AUTH"
            sleep 2
        done ;;
    *)
        echo "Pemakaian: prab -> ttl | ubah | kembali ; alpha -> setup | pantau" ;;
esac
