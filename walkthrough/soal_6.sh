#!/bin/bash

# Mendapatkan hostname node saat ini
CURRENT_HOST=$(hostname)

case "$CURRENT_HOST" in
    "alpha")
        echo "Melakukan pengujian record SOA domain k04.com dari alpha..."
        
        echo "=== Query ke Master DNS (192.213.1.2) ==="
        dig @192.213.1.2 k04.com SOA +short
        
        echo "=== Query ke Slave DNS (192.213.1.3) ==="
        dig @192.213.1.3 k04.com SOA +short
        ;;

    *)
        echo "Hostname '$CURRENT_HOST' tidak menjalankan pengujian SOA ini."
        ;;
esac