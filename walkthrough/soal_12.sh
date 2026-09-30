#!/bin/bash
# Soal 12 - Basic authentication untuk path /admin di penny
#   username: prabs
#   password: pakar_pinter_jadi_gob***

CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "penny")
        echo "Mengonfigurasi basic auth /admin pada penny..."
        apt install apache2-utils -y

        # Membuat file password (-c = buat baru, -b = password dari argumen)
        htpasswd -cb /etc/apache2/.htpasswd prabs 'pakar_pinter_jadi_gob***'

        mkdir -p /var/www/admin
        echo "<h1>Dokumen Rahasia Sindikat - Penny</h1>" > /var/www/admin/index.html

        cat <<'EOF' > /etc/apache2/penny-extra/admin.conf
ProxyPass /admin !
Alias /admin /var/www/admin

<Directory /var/www/admin>
    AuthType Basic
    AuthName "Ruang Rahasia Penny"
    AuthUserFile /etc/apache2/.htpasswd
    Require valid-user
</Directory>
EOF

        apache2ctl configtest && service apache2 restart
        ;;

    "alpha")
        echo "=== Tanpa login ==="
        curl -s -o /dev/null -w "HTTP %{http_code}\n" http://www.k04.com/admin/
        echo "=== Password salah ==="
        curl -s -o /dev/null -w "HTTP %{http_code}\n" -u 'prabs:salah' http://www.k04.com/admin/
        echo "=== Login benar ==="
        curl -s -w "\nHTTP %{http_code}\n" -u 'prabs:pakar_pinter_jadi_gob***' http://www.k04.com/admin/
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak memerlukan aksi khusus pada skrip
