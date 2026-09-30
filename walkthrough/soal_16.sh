#!/bin/bash
# Soal 16 - Stress test ApacheBench dari alpha
#   250 request, konkurensi 10, ke www.k04.com dan static.k04.com

CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "alpha")
        echo "Menjalankan benchmark ApacheBench dari alpha..."
        apt update
        apt install apache2-utils -y

        for target in www.k04.com static.k04.com; do
            ab -n 250 -c 10 "http://$target/" > /root/ab_$target.txt 2>&1
        done

        for target in www.k04.com static.k04.com; do
            echo "===== Benchmark http://$target/ (-n 250 -c 10) ====="
            grep -E "Server Software|Server Hostname|Concurrency Level|Complete requests|Failed requests|Exceptions|Non-2xx|Requests per second|Time per request|Transfer rate" /root/ab_$target.txt
            echo ""
        done
        ;;

    *)
        echo "Soal 16 dijalankan dari node alpha."
        ;;
esac
