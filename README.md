# PRAKTIKUM JARKOM MODUL 2 KELOMPOK 4 - 2026

## Anggota

| Nama | NRP |
| :---: | :---: |
| Albert Chen | 5027251034 |
| Boma Sahya Aryaguna | 5027251125 |

## Laporan

1. Sebagai pusat kesadaran The Mesh, `rootkit` bertindak sebagai router utama yang merentangkan koneksinya ke lima gerbang utama (Switch) yang berbeda. Pada tahap awal ini, kami merancang skema pengalamatan IP menggunakan blok privat kelas C dengan mengalokasikan subnet `/24` yang unik untuk setiap segmen jaringan, memastikan seluruh entitas dapat terhubung secara terstruktur melalui default gateway yang tepat.

![topology](assets/topology.png)

**Konfigurasi Jaringan**

Berikut adalah detail konfigurasi alamat IP dan gateway yang diterapkan pada setiap node menggunakan file `/etc/network/interfaces`:

**rootkit**  
```bash
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
```

**prab**
```bash
auto eth0
iface eth0 inet static
	address 192.213.1.2
	netmask 255.255.255.0
	gateway 192.213.1.1
```

**tedd**
```bash
auto eth0
iface eth0 inet static
	address 192.213.1.3
	netmask 255.255.255.0
	gateway 192.213.1.1
```

**obladi**
```bash
auto eth0
iface eth0 inet static
	address 192.213.1.4
	netmask 255.255.255.0
	gateway 192.213.1.1
```

**desmond**
```bash
auto eth0
iface eth0 inet static
	address 192.213.1.5
	netmask 255.255.255.0
	gateway 192.213.1.1
```

**oblada**
```bash
auto eth0
iface eth0 inet static
	address 192.213.1.6
	netmask 255.255.255.0
	gateway 192.213.1.1
```

**molly**
```bash
auto eth0
iface eth0 inet static
	address 192.213.1.7
	netmask 255.255.255.0
	gateway 192.213.1.1
```

**alpha**
```bash
auto eth0
iface eth0 inet static
	address 192.213.2.2
	netmask 255.255.255.0
	gateway 192.213.2.1
```

**beta**
```bash
auto eth0
iface eth0 inet static
	address 192.213.2.3
	netmask 255.255.255.0
	gateway 192.213.2.1
```

**gamma**
```bash
auto eth0
iface eth0 inet static
	address 192.213.2.4
	netmask 255.255.255.0
	gateway 192.213.2.1
```

**delta**
```bash
auto eth0
iface eth0 inet static
	address 192.213.3.2
	netmask 255.255.255.0
	gateway 192.213.3.1
```

**epsilon**
```bash
auto eth0
iface eth0 inet static
	address 192.213.3.3
	netmask 255.255.255.0
	gateway 192.213.3.1
```

**abbey**
```bash
auto eth0
iface eth0 inet static
	address 192.213.4.2
	netmask 255.255.255.0
	gateway 192.213.4.1
```

**penny**
```bash
auto eth0
iface eth0 inet static
	address 192.213.5.2
	netmask 255.255.255.0
	gateway 192.213.5.1
```

**Validasi**  
Untuk membuktikan bahwa konfigurasi dasar ini telah terpasang dengan benar, dilakukan pengujian konektivitas dasar dari masing-masing node menuju ke default gateway-nya.

**Cara Validasi:** Menggunakan perintah `ping` dari host ke alamat IP gateway masing-masing segmen. Sebagai contoh, dari node `alpha` (`192.213.2.2`), dilakukan pengecekan ke gateway:
```bash
ping 192.213.2.1
```

**Hasil yang diharapkan:** Mendapatkan balasan (reply) secara konsisten dari router `rootkit`. Hal ini mengonfirmasi bahwa:
- Konfigurasi alamat IP dan netmask pada setiap node sudah valid.
- Konektivitas fisik maupun Layer 2 melalui switch menuju router `rootkit` berfungsi dengan sempurna.
- Konfigurasi interface pada router pusat (`rootkit`) telah aktif dan siap meneruskan paket data antar-segmen.


2. Meskipun The Mesh beroperasi dalam bayang-bayang, `rootkit` menyadari bahwa seluruh Entitas di dalamnya masih membutuhkan akses komunikasi menuju dunia luar. Oleh karena itu, pada tahap ini dilakukan konfigurasi Network Address Translation (NAT) pada router pusat `rootkit` agar seluruh host di jaringan internal dapat menjangkau internet publik.

Dengan mengaktifkan NAT, `rootkit` akan menerjemahkan (masquerade) alamat IP privat dari setiap node internal menjadi alamat IP publik miliknya pada interface WAN (`eth0`) saat keluar menuju internet. Hal ini memungkinkan berbagai segmen jaringan internal berbagi satu jalur koneksi luar secara bersamaan.

**Konfigurasi di Rootkit**

Langkah pertama dilakukan langsung pada router pusat `rootkit`. Kami menginstal utilitas `iptables` (jika belum tersedia) dan menambahkan aturan masquerade untuk seluruh subnet internal `192.213.0.0/16` yang keluar melalui interface `eth0`
```bash
apt update
apt install iptables -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.213.0.0/16
```

**Validasi**
Untuk membuktikan bahwa konfigurasi NAT berhasil dan lalu lintas internet dapat dijangkau dari dalam jaringan, dilakukan pengujian konektivitas dari salah satu node internal (misalnya `prab`).

**Cara Validasi:** Menggunakan perintah `ping` langsung ke alamat IP publik eksternal (menggunakan DNS Publik Google di `8.8.8.8`) guna memastikan konektivitas murni tanpa kendala resolusi DNS:
```bash
ping 8.8.8.8
```

**Hasil yang diharapkan:** Node prab (dengan IP privat `192.213.1.2`) berhasil menerima balasan (reply) dari `8.8.8.8`. Hal ini mengonfirmasi bahwa:
- Paket dari node internal berhasil diteruskan oleh `rootkit`  .
- `rootkit` sukses melakukan masquerade IP sumber privat menjadi IP publik pada interface WAN (`eth0`).
- Lalu lintas data dari internet berhasil kembali dan diterjemahkan ulang oleh `rootkit` menuju node internal yang meminta.

3. Jaringan rahasia tidak akan berfungsi tanpa sinkronisasi antar divisi. Pada tahap ini, dipastikan seluruh Entitas dapat saling terhubung dan berkomunikasi lintas jalur melalui router pusat `rootkit`. Selain itu, untuk menghindari kendala saat instalasi paket, setiap host non-router dikonfigurasi dengan resolver DNS lokal agar akses unduh dari internet dapat langsung tersedia sejak awal.

**Konfigurasi**

1. Routing Internal: Konektivitas antar-subnet (lintas jalur antar-segmen jaringan yang terhubung ke `rootkit`) secara implisit telah aktif berkat fungsionalitas IP forwarding pada router pusat `rootkit`. Hal ini memungkinkan `rootkit` untuk meneruskan paket data dari satu segmen jaringan ke segmen lainnya dengan mulus.
2. Resolver DNS Awal: Agar setiap host non-router dapat melakukan resolusi nama domain guna mengunduh paket instalasi dari internet, ditambahkan nameserver `192.168.122.1` ke dalam file `/etc/resolv.conf` pada masing-masing host:
```bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

**Validasi**

Untuk memastikan bahwa routing lintas segmen dan akses internet via DNS berjalan dengan baik, dilakukan dua jenis pengujian dari node `prab`:

1. Validasi Routing Internal: Pengujian dilakukan untuk membuktikan bahwa `rootkit` berhasil merutekan trafik lintas jalur (dari segmen `192.213.1.0/24` menuju segmen operator di `192.213.2.0/24`):
```bash
ping 192.213.2.2
```
Hasil yang diharapkan: Mendapat balasan (reply) secara konsisten, menandakan router pusat `rootkit` berfungsi sempurna sebagai penghubung antar-sub jaringan.

2. Validasi Resolver DNS dan Akses Internet: Pengujian dilakukan untuk memastikan kemampuan resolusi domain dan konektivitas keluar:
```bash
ping google.com
```
Hasil yang diharapkan: Domain `google.com` berhasil di-resolve ke alamat IP publik dan mendapatkan balasan ping, membuktikan bahwa konfigurasi resolver `/etc/resolv.conf` telah aktif dan jalur internet siap digunakan untuk kebutuhan instalasi paket.

4. Penjaga Direktori mulai menuliskan hukum The Mesh dengan membangun sistem DNS internal yang andal. Pada tahap ini, node `prab` dikonfigurasi sebagai server DNS master (utama) dan node `tedd` sebagai server DNS slave (cadangan) untuk domain `k04.com`. Implementasi ini bertujuan untuk memastikan redundansi data domain, sehingga jika server utama mengalami kendala, server cadangan dapat mengambil alih layanan resolusi nama secara mulus.

**Konfigurasi di Prab (DNS Master)**

Langkah pertama dilakukan pada node `prab` (`192.213.1.2`) dengan menginstal paket `BIND9`, mengatur direktori zona, serta mendefinisikan record untuk domain `k04.com`.

- Instalasi dan Konfigurasi Opsi: Mengatur BIND9 agar meneruskan (forward) query yang tidak dikenal ke DNS publik `192.168.122.1`
```bash
apt update
apt install bind9 -y
ln -s /etc/init.d/named /etc/init.d/bind9
```

![prab-bind-package](assets/prab-bind-package.png)

```bash
options {
    directory "/var/cache/bind";
    forwarders {
        192.168.122.1;
    };
    allow-query { any; };
    auth-nxdomain no;
    listen-on { any; };
    listen-on-v6 { any; };
};
```

![prab-named-options](assets/prab-named-options.png)

- Pembuatan File Zona: Membuat catatan SOA, NS, serta A record untuk menghubungkan hostname ke IP masing-masing dan domain apex ke gerbang aplikasi dinamis (`penny` di `192.213.5.2`)
```bash
$TTL    604800          ; Waktu cache default (detik)
@       IN      SOA     prab.k04.com. root.k04.com. (
                        2026092801 ; Serial (format YYYYMMDDXX)
                        604800     ; Refresh (1 minggu)
                        86400      ; Retry (1 hari)
                        2419200    ; Expire (4 minggu)
                        604800 )   ; Negative Cache TTL

@       IN      NS      prab.k04.com.
@       IN      NS      tedd.k04.com.

prab    IN      A       192.213.1.2
tedd    IN      A       192.213.1.3

@       IN      A       192.213.5.2
```

![zone conf](assets/zone-conf-k04.png)

- Pendaftaran Zona Master: Mendaftarkan zona `k04.com` dan memberikan izin transfer data ke node `tedd` (`192.213.1.3`) serta mengaktifkan notifikasi pembaruan:
```bash
zone "k04.com" {
    type master;
    file "/etc/bind/k04/k04.com";
    allow-transfer { 192.213.1.3; };
    notify yes;
};
```

![config zone local](assets/config-zone-local-prab.png)

Lalu jalankan ulang layanan BIND9:
```bash
service bind9 restart
```

![prab restart bind](assets/prab-restart-bind.png)

Konfigurasi di Semua Klien
```bash
echo "nameserver 192.213.1.2" > /etc/resolv.conf
echo "nameserver 192.213.1.3" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
```
```bash
dig @localhost k04.com
```
![dig result prab](assets/dig-result-prab.png)

**Konfigurasi di Tedd (DNS Slave)**

Di node `tedd` (`192.213.1.3`), BIND9 dikonfigurasi sebagai slave yang akan menarik data zona secara otomatis dari master (`prab`).

Pendaftaran Zona Slave
```bash
apt update
apt install bind9 -y
ln -s /etc/init.d/named /etc/init.d/bind9
```
```
zone "k04.com" {
    type slave;
    masters { 192.213.1.2; };
    file "/var/lib/bind/k04/k04.com";
};
```
Menyiapkan direktori penyimpanan cache dan merestart layanan:
```bash
mkdir -p /var/lib/bind/k04 && chown bind:bind /var/lib/bind/k04
service bind9 restart
```

![tedd named local](assets/tedd-named-local.png)

```bash
service bind9 restart
```

![tedd restart bind](assets/tedd-restart-bind.png)

![tedd transfer ok](assets/tedd-transfer-ok.png)

![dig result tedd](assets/dig-result-tedd.png)

Agar seluruh entitas non-router memprioritaskan server DNS internal sebelum melempar ke DNS luar, urutan resolver pada file `/etc/resolv.conf` di setiap host diperbarui menjadi:
```bash
echo "nameserver 192.213.1.2" > /etc/resolv.conf
echo "nameserver 192.213.1.3" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
```

**Validasi**

Untuk membuktikan bahwa sistem DNS master-slave berjalan dengan benar, dilakukan pengujian query dari node klien (misalnya `alpha`) menggunakan perintah `dig`:

Cara Validasi:
```bash
dig k04.com
```

Hasil yang diharapkan:
- Perintah `dig` mengembalikan respons pada Answer Section yang menunjukkan bahwa domain `k04.com` berhasil diterjemahkan ke alamat IP gerbang aplikasi dinamis `penny` (`192.213.5.2`).
- Server DNS yang melayani permintaan (`SERVER: 192.213.1.2#53` atau `192.213.1.3#53`) merespons secara authoritative, mengonfirmasi bahwa sinkronisasi antara master (`prab`) dan slave (`tedd`) telah berhasil dilakukan.

![other client dns ok](assets/other-client-dns-ok.png)

5. "Entitas tanpa identitas adalah anomali," pesan Rootkit. Agar setiap entitas di dalam jaringan dapat dikenali dan dihubungi melalui nama yang terstruktur, tahap ini berfokus pada penambahan A record untuk seluruh node non-router (`alpha`, `beta`, `gamma`, `delta`, `epsilon`, `abbey`, `penny`, `obladi`, `desmond`, `oblada`, dan `molly`) ke dalam server DNS master (`prab`). Sesuai aturan, pengecualian diberikan kepada node yang bertanggung jawab langsung atas layanan DNS (`prab` dan `tedd`) karena record mereka telah didefinisikan sebelumnya pada tahap awal pembuatan zona.

**Penambahan A Record pada Server Master (Prab)**

Semua pemetaan nama host ke alamat IP statis masing-masing ditambahkan ke dalam file zona DNS utama milik domain `k04.com`
```bash
cat <<EOF >> /etc/bind/k04/k04.com
alpha       IN      A       192.213.2.2
beta        IN      A       192.213.2.3
gamma       IN      A       192.213.2.4
delta       IN      A       192.213.3.2
epsilon     IN      A       192.213.3.3
abbey       IN      A       192.213.4.2
penny       IN      A       192.213.5.2
obladi      IN      A       192.213.1.4
desmond     IN      A       192.213.1.5
oblada      IN      A       192.213.1.6
molly       IN      A       192.213.1.7

EOF
```

![update subdomain perhost](assets/update-subdomain-perhost.png)

```bash
service bind9 restart
```

**Validasi**

Untuk membuktikan bahwa seluruh subdomain baru tersebut dapat dikenali secara system-wide dan berfungsi dengan benar di lintas segmen jaringan, dilakukan pengujian konektivitas menggunakan perintah `ping` dari salah satu klien (misalnya `alpha`):

Cara Validasi: Menguji resolusi nama dan konektivitas ke beberapa node dari segmen yang berbeda:
```bash
ping beta.k04.com
ping obladi.k04.com
ping epsilon.k04.com
```

![check subdo ok](assets/check-subdo-ok.png)

Hasil yang Diharapkan:

- Resolusi Nama Berhasil: Nama domain lengkap (seperti `beta.k04.com`, `obladi.k04.com`, dan `epsilon.k04.com`) berhasil diterjemahkan oleh server DNS master/slave ke alamat IP masing-masing secara akurat.

- Konektivitas Terjalin: Perintah `ping` menerima balasan (reply) dari host tujuan. Keberhasilan ini memvalidasi bahwa seluruh A record subdomain telah terdaftar dengan benar dan routing lintas segmen berfungsi secara utuh di seluruh jaringan The Mesh.

6. Sinkronisasi antara pusat direktori utama dan cadangan merupakan hal mutlak; `tedd` telah menerima salinan zona terbaru dari `prab`. Nilai serial SOA di kedua server DNS tersebut dipastikan sama persis karena keduanya saling melengkapi dalam menjaga ketersediaan layanan nama domain.

Zone transfer adalah mekanisme replikasi data zona dari server DNS master (`prab`) ke server slave (`tedd`). Keberhasilan proses ini dikontrol oleh nomor seri SOA (Start of Authority). Ketika server master mengalami pembaruan data, nomor seri SOA harus dinaikkan agar server slave mendeteksi perubahan dan melakukan penyalinan data secara otomatis maupun melalui notifikasi langsung (notify).

**Validasi**

Untuk membuktikan bahwa mekanisme zone transfer berjalan dengan sukses dan kedua server memiliki salinan data yang identik, dilakukan pengujian query DNS menggunakan utilitas `dig` dari sisi klien (`alpha`):

Cara Validasi: Melakukan query tipe SOA secara spesifik ke server master (`prab` di `192.213.1.2`) dan server slave (`tedd` di `192.213.1.3`) menggunakan parameter `+short` untuk menampilkan output ringkas
```bash
dig @192.213.1.2 k04.com SOA +short
dig @192.213.1.3 k04.com SOA +short
```

Hasil yang Diharapkan: Output nilai serial SOA (misalnya `2026092801`) yang dikembalikan oleh kedua perintah tersebut harus identik dan sama persis. Kesamaan nilai ini mengonfirmasikan bahwa:
- Mekanisme zone transfer dari master (`prab`) ke slave (`tedd`) berhasil dilakukan dengan sempurna.
- Redundansi dan konsistensi data pada sistem DNS master-slave The Mesh terjaga tanpa adanya perbedaan informasi.

![check serial key dns](assets/check-serial-key-dns.png)

7. Dalam arsitektur jaringan The Mesh, `abbey` dan `penny` berperan sebagai gerbang utama, `obladi` dan `desmond` mengelola area web statis (Vault), serta `oblada` dan `molly` mengelola area web dinamis (Core). Untuk memudahkan akses layanan menggunakan nama panggilan yang umum, dilakukan penambahan A record bagi klaster layanan serta CNAME record (Canonical Name) untuk menghubungkan domain umum ke hostname spesifik masing-masing entitas.

Semua perubahan konfigurasi DNS dilakukan pada server master (`prab`). Kami menambahkan A record untuk `vault` dan `core` (yang masing-masing mengarah ke dua alamat IP menggunakan teknik Round-Robin DNS), serta menetapkan CNAME record untuk `www` dan `static`
```bash
cat <<EOF >> /etc/bind/k04/k04.com
vault       IN      A       192.213.1.4
vault       IN      A       192.213.1.5
core        IN      A       192.213.1.6
core        IN      A       192.213.1.7

www         IN      CNAME   penny.k04.com.
static      IN      CNAME   abbey.k04.com.

EOF
```

Setelah file disimpan, layanan BIND9 dimuat ulang agar perubahan diterapkan

![add cname vault core dns](assets/add-cname-vault-core-dns.png)

```bash
service bind9 restart
```

**Validasi**

Untuk membuktikan bahwa pemetaan A record klaster dan CNAME record berfungsi dengan benar serta terpropagasi secara konsisten, dilakukan verifikasi dari dua klien berbeda (yaitu `alpha` dan `delta`) menggunakan utilitas `dig`

1. Pengujian dari klien `alpha`
```bash
dig www.k04.com +short
dig static.k04.com +short
dig vault.k04.com +short
dig core.k04.com +short
```

2. Pengujian dari klien `delta`
```bash
dig www.k04.com +short
dig static.k04.com +short
dig vault.k04.com +short
dig core.k04.com +short
```

**Hasil yang Diharapkan:** 
- Query untuk `[www.k04.com](https://www.k04.com)` dan `static.k04.com` berhasil mengembalikan target canonical name atau alamat IP tujuan secara tepat.

- Query untuk klaster `vault.k04.com` dan `core.k04.com` secara konsisten mengembalikan daftar alamat IP dari node-node di bawahnya (`192.213.1.4` dan `192.213.1.5` untuk Vault, serta `192.213.1.6` dan `192.213.1.7` untuk Core).

- Hasil pengujian dari kedua klien (`alpha` dan `delta`) menunjukkan respons yang identik dan konsisten, memvalidasi bahwa seluruh record DNS telah berhasil disebarkan ke seluruh jaringan The Mesh.

![from alpha test ok](assets/from-alpha-test-ok.png)

![from delta test ok](assets/from-delta-test-ok.png)

8. Untuk memastikan bahwa setiap alamat IP pada node-node utama (meliputi abbey, penny, area vault / obladi & desmond, serta area core / oblada & molly) dapat melacak balik ke nama host yang bersesuaian secara akurat dan authoritative, dilakukan konfigurasi Reverse DNS (PTR Record) pada server master (`prab` / `ns1`) serta sinkronisasi slave pada server `tedd` (`ns2`).

**Konfigurasi di Prab (DNS Master)**

Pertama, kami mendeklarasikan reverse zone untuk segmen-segmen jaringan tempat node-node tersebut berada di dalam file `/etc/bind/named.conf.local`, lengkap dengan aturan allow-transfer ke server slave (`tedd` di `192.213.1.3`)
```bash
cat <<EOF >> /etc/bind/named.conf.local

zone "1.213.192.in-addr.arpa" {
    type master;
    file "/etc/bind/k04/1.213.192.in-addr.arpa";
    allow-transfer { 192.213.1.3; };
};

zone "4.213.192.in-addr.arpa" {
    type master;
    file "/etc/bind/k04/4.213.192.in-addr.arpa";
    allow-transfer { 192.213.1.3; };
};

zone "5.213.192.in-addr.arpa" {
    type master;
    file "/etc/bind/k04/5.213.192.in-addr.arpa";
    allow-transfer { 192.213.1.3; };
};
EOF
```

Selanjutnya, kami membuat dan mengisi masing-masing file zone dengan record PTR untuk memetakan alamat IP ke hostname yang benar (`abbey`, `penny`, vault, core, serta server DNS itu sendiri)

**File Zona Segmen 1**
```bash
cat <<EOF > /etc/bind/k04/1.213.192.in-addr.arpa
\$TTL    604800
@       IN      SOA     prab.k04.com. root.k04.com. (
                        2026092801 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL

@       IN      NS      prab.k04.com.
@       IN      NS      tedd.k04.com.

2       IN      PTR     prab.k04.com.
3       IN      PTR     tedd.k04.com.
4       IN      PTR     obladi.k04.com.
5       IN      PTR     desmond.k04.com.
6       IN      PTR     oblada.k04.com.
7       IN      PTR     molly.k04.com.
EOF
```

**File Zona Segmen 4**
```bash
cat <<EOF > /etc/bind/k04/4.213.192.in-addr.arpa
\$TTL    604800
@       IN      SOA     prab.k04.com. root.k04.com. (
                        2026092801 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL

@       IN      NS      prab.k04.com.
@       IN      NS      tedd.k04.com.

2       IN      PTR     abbey.k04.com.
EOF
```

**File Zona Segmen 5**
```bash
cat <<EOF > /etc/bind/k04/5.213.192.in-addr.arpa
\$TTL    604800
@       IN      SOA     prab.k04.com. root.k04.com. (
                        2026092801 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL

@       IN      NS      prab.k04.com.
@       IN      NS      tedd.k04.com.

2       IN      PTR     penny.k04.com.
EOF
```

Setelah konfigurasi selesai, layanan BIND9 direstart untuk menerapkan perubahan:
```bash
service bind9 restart
```

**Konfigurasi di Tedd (DNS Slave)**

Di server slave `tedd`, kami mendaftarkan ketiga reverse zone tersebut dengan tipe `slave` dan mengarahkannya ke server master (`192.213.1.2`) agar melakukan zone transfer secara otomatis:
```bash
cat <<EOF >> /etc/bind/named.conf.local

zone "1.213.192.in-addr.arpa" {
    type slave;
    masters { 192.213.1.2; };
    file "/var/lib/bind/k04/1.213.192.in-addr.arpa";
};

zone "4.213.192.in-addr.arpa" {
    type slave;
    masters { 192.213.1.2; };
    file "/var/lib/bind/k04/4.213.192.in-addr.arpa";
};

zone "5.213.192.in-addr.arpa" {
    type slave;
    masters { 192.213.1.2; };
    file "/var/lib/bind/k04/5.213.192.in-addr.arpa";
};
EOF
```

Layanan BIND9 di `tedd` kemudian direstart:
```bash
service bind9 restart
```

**Verifikasi**

Pengujian reverse lookup dilakukan dari node klien (`alpha`) untuk memastikan bahwa pencarian balik alamat IP mengembalikan hostname yang benar dan dijawab secara authoritative
```bash
host -t ptr 192.213.4.2
host -t ptr 192.213.5.2
host -t ptr 192.213.1.4
host -t ptr 192.213.1.6
```

Hasil yang Diharapkan:

Setiap perintah reverse lookup di atas berhasil memetakan alamat IP tujuan kembali ke hostname aslinya masing-masing (`abbey.k04.com`, `penny.k04.com`, `obladi.k04.com`, dan `oblada.k04.com`), membuktikan bahwa konfigurasi Reverse DNS dan replikasi zone transfer berjalan dengan sukses dan konsisten di seluruh jaringan.

![soal 8](assets/soal_8.png)

9. Pada area vault dari arsitektur jaringan The Mesh, node `obladi` dan `desmond` ditugaskan untuk menjalankan layanan web statis menggunakan Apache HTTP Server. Selain itu, direktori `/arsip/` dikonfigurasi dengan fitur autoindex (directory listing) aktif agar seluruh daftar file di dalamnya dapat ditelusuri langsung melalui browser atau perintah klien menggunakan hostname masing-masing.

**Konfigurasi di Obladi (Web Statis)**

Langkah pertama adalah melakukan instalasi Apache2 pada node `obladi`, membuat direktori penyimpanan arsip, serta mengatur konfigurasi Virtual Host agar mengarah ke direktori tersebut dengan fitur indexes diaktifkan:
```bash
apt update
apt install apache2 -y

mkdir -p /var/www/arsip/

cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerName obladi.k04.com
    ServerAdmin webmaster@obladi.k04.com
    DocumentRoot /var/www/arsip

    <Directory /var/www/arsip>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF

service apache2 restart
```

**Konfigurasi di Desmond (Web Statis)**

Langkah serupa juga diterapkan pada node `desmond` untuk memastikan layanan web statis berjalan secara konsisten di area vault
```bash
apt update
apt install apache2 -y

mkdir -p /var/www/arsip/

cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerName desmond.k04.com
    ServerAdmin webmaster@desmond.k04.com
    DocumentRoot /var/www/arsip

    <Directory /var/www/arsip>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF

service apache2 restart
```

**Validasi**

Untuk membuktikan bahwa layanan web statis dan fitur autoindex berjalan dengan benar, pengujian dilakukan dari mesin klien (`alpha`) dengan mengakses langsung melalui hostname (bukan alamat IP):
```bash
curl http://obladi.k04.com
curl http://desmond.k04.com
```

Hasil yang Diharapkan: Perintah `curl` berhasil mengembalikan output berupa kode HTML yang secara otomatis dihasilkan oleh Apache (`Index of /`), menandakan bahwa fitur autoindex aktif dan direktori `/arsip/` berhasil disajikan serta ditelusuri melalui hostname masing-masing node vault.

![soal 9](assets/soal_9.png)

10. Pada area core dari arsitektur jaringan The Mesh, node `oblada` dan `molly` ditugaskan untuk menjalankan layanan web dinamis menggunakan Nginx dan PHP-FPM. Selain itu, diterapkan aturan URL rewrite pada server agar halaman seperti `/profil` dapat diakses secara bersih tanpa menggunakan akhiran `.php`, dengan pengujian wajib dilakukan melalui hostname masing-masing.

**Konfigurasi di Oblada (Web Dinamis)**

Langkah pertama adalah memperbarui repositori dan menginstal Nginx serta PHP-FPM pada node `oblada`. Selanjutnya, dibuat direktori web root `/var/www/html` beserta file aplikasi sederhana (`index.php` dan `profil.php`)
```bash
apt update
apt install nginx php-fpm -y

mkdir -p /var/www/html

cat <<EOF > /var/www/html/index.php
<?php
echo "<h1>Selamat Datang di Beranda Core (Oblada)</h1>";
echo "<p>Ini adalah halaman utama web dinamis.</p>";
?>
EOF

cat <<EOF > /var/www/html/profil.php
<?php
echo "<h1>Halaman Profil Oblada</h1>";
echo "<p>Ini adalah halaman profil resmi dari area core (oblada).</p>";
?>
EOF
```

Kemudian, konfigurasi Virtual Host Nginx disesuaikan untuk mendefinisikan server_name, mengaktifkan aturan rewrite untuk URL bersih, serta menangani eksekusi file PHP menggunakan Unix Socket PHP-FPM
```bash
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm;

    server_name oblada.k04.com core.k04.com;

    # Aturan URL Rewrite agar /profil bisa diakses tanpa .php
    location / {
        try_files \$uri \$uri/ @rewrite;
    }

    location @rewrite {
        rewrite ^/(.*)\$ /\$1.php last;
    }

    # Penanganan file PHP menggunakan PHP-FPM Unix Socket
    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

service php8.4-fpm restart
service nginx restart
```

**Konfigurasi di Molly (Web Dinamis)**

Langkah serupa juga diterapkan pada node `molly` untuk memastikan layanan web dinamis berjalan secara konsisten di area core
```bash
apt update
apt install nginx php-fpm -y

mkdir -p /var/www/html

cat <<EOF > /var/www/html/index.php
<?php
echo "<h1>Selamat Datang di Beranda Core (Molly)</h1>";
echo "<p>Ini adalah halaman utama web dinamis.</p>";
?>
EOF

cat <<EOF > /var/www/html/profil.php
<?php
echo "<h1>Halaman Profil Molly</h1>";
echo "<p>Ini adalah halaman profil resmi dari area core (molly).</p>";
?>
EOF

cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm;

    server_name molly.k04.com core.k04.com;

    # Aturan URL Rewrite agar /profil bisa diakses tanpa .php
    location / {
        try_files \$uri \$uri/ @rewrite;
    }

    location @rewrite {
        rewrite ^/(.*)\$ /\$1.php last;
    }

    # Penanganan file PHP menggunakan PHP-FPM Unix Socket
    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

service php8.4-fpm restart
service nginx restart
```

**Validasi**

Untuk membuktikan bahwa layanan web dinamis berbasis Nginx dan PHP-FPM serta aturan URL rewrite berfungsi dengan benar, pengujian dilakukan dari mesin klien (`alpha`) menggunakan perangkat baris perintah `curl` dengan mengakses langsung melalui hostname
```bash
# Menguji halaman utama (beranda)
curl http://oblada.k04.com/
curl http://molly.k04.com/

# Menguji halaman profil dengan URL bersih (tanpa akhiran .php)
curl http://oblada.k04.com/profil
curl http://molly.k04.com/profil
```

Hasil yang Diharapkan:
- Perintah `curl` ke halaman utama berhasil mengeksekusi skrip `index.php` dan mengembalikan teks sambutan beranda masing-masing node.

- Perintah `curl` ke `/profil` berhasil diterjemahkan oleh aturan rewrite Nginx ke file `profil.php` tanpa menampilkan ekstensi file, membuktikan bahwa arsitektur web dinamis area core berjalan dengan sukses dan responsif di seluruh jaringan The Mesh.

![soal 10](assets/soal_10.png)