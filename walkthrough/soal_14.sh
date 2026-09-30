#!/bin/bash
# Soal 14 - Access log backend mencatat IP asli pengunjung
#   vault (Apache) : mod_remoteip, percaya X-Real-IP dari penny (192.213.5.2)
#   core  (Nginx)  : real_ip, percaya X-Real-IP dari abbey (192.213.4.2)

CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "obladi"|"desmond")
        echo "Mengaktifkan mod_remoteip pada $CURRENT_HOST..."
        a2enmod remoteip

        cat <<'EOF' > /etc/apache2/conf-available/realip.conf
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 192.213.5.2
LogFormat "%a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
EOF
        a2enconf realip
        apache2ctl configtest && service apache2 restart
        ;;

    "oblada"|"molly")
        echo "Mengaktifkan real_ip Nginx pada $CURRENT_HOST..."
        cat <<'EOF' > /etc/nginx/conf.d/realip.conf
set_real_ip_from 192.213.4.2;
real_ip_header   X-Real-IP;
EOF
        nginx -t && service nginx restart
        ;;

    "alpha")
        for i in 1 2 3 4; do
