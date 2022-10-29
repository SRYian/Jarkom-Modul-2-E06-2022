# WISE DNS Server config
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install bind9 -y

# Nomor 2 wise.E06.com dengan alias www.wise.E06.com pada folder wise
# nama domain = wise.E06.com
# nano /etc/bind/named.conf.local
echo 'zone "wise.E06.com" {
    type master;
    also-notify { 192.195.2.2; }; // Masukan IP
    allow-transfer { 192.195.2.2; }; // Masukan IP
    file "/etc/bind/wise/wise.E06.com";

};'>/etc/bind/named.conf.local

mkdir /etc/bind/wise
# cp /etc/bind/db.local /etc/bind/wise/wise.E06.com
# nano /etc/bind/wise/wise.E06.com
echo "restart one"
# named -g
service bind9 restart

echo "
\$TTL    604800
@       IN      SOA     wise.E06.com. root.wise.E06.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      wise.E06.com.
@       IN      A       192.195.3.2
@       IN      AAAA    ::1
" > /etc/bind/wise/wise.E06.com


echo "www     IN      CNAME   wise.E06.com.">>/etc/bind/wise/wise.E06.com

# named -g
service bind9 restart

#SAMPAI SINI AMAN

# 3 Buat subdomain subdomain eden.wise.E06.com dengan alias www.eden.wise.E06.com

# belum dimasukin
echo "eden     IN      A   192.195.2.3">>/etc/bind/wise/wise.E06.com
# echo "www     IN      CNAME   eden.wise.E06.com.">>/etc/bind/wise/wise.E06.com

# ip WISE 192.195.3.2
echo "
ns1     IN      A       192.195.2.3 ;
super   IN      NS      ns1
" >> /etc/bind/wise/wise.E06.com


#eden.wise
echo "
\$TTL    604800
@       IN      SOA     eden.wise.E06.com. root.eden.wise.E06.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      eden.wise.E06.com.
@       IN      A       192.195.3.2
www     IN      CNAME   eden.wise.E06.com.
" > /etc/bind/wise/eden.wise.E06.com

echo 'zone "eden.wise.E06.com" {
    type master;
    file "/etc/bind/wise/eden.wise.E06.com";
};'>>/etc/bind/named.conf.local


# Nomor 4 Buat juga reverse domain untuk domain utama
# nano /etc/bind/named.conf.local
echo 'zone "3.195.192.in-addr.arpa" {
    type master;
    file "/etc/bind/wise/3.195.192.in-addr.arpa";
};' >> /etc/bind/named.conf.local

# cp /etc/bind/db.local /etc/bind/wise/3.195.192.in-addr.arpa
# nano /etc/bind/wise/3.195.192.in-addr.arpa
# nano /etc/bind/wise/wise.E06.coms

echo "\$TTL    604800
@       IN      SOA     wise.E06.com. root.wise.E06.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
3.195.192.in-addr.arpa.       IN      NS      wise.E06.com.
2       IN      PTR     wise.E06.com.
" > /etc/bind/wise/3.195.192.in-addr.arpa


# named -g
service bind9 restart

# Nomor 5 buatlah juga Berlint sebagai DNS Slave untuk domain utama
# dilakukan di config awal agar tidak merusak bash
# File Wise
# ip Berlint: 192.195.2.2
# echo 'zone "wise.E06.com" {
#     type master;
#     notify yes;
#     also-notify { 192.195.2.2; }; // Masukan IP Water7 tanpa tanda petik
#     allow-transfer { 192.195.2.2; }; // Masukan IP Water7 tanpa tanda petik

# };
# '>>/etc/bind/named.conf.local

# File Berlint
# named -g
service bind9 restart
#SSS and Garden client setup



# Nomor 6 Karena banyak informasi dari Handler, buatlah subdomain yang khusus untuk operation
# yaitu operation.wise.yyy.com dengan alias www.operation.wise.yyy.com
# yang didelegasikan dari WISE ke Berlint dengan IP menuju ke Eden dalam folder operation

# tambahin ini
# ns1       IN      A     192.195.2.2 ; IP Berlint
# operation IN      NS    ns1

# file /etc/bind/named.conf.options, tambahkan allow-query{any;}
# MASIH ERROR
echo 'options {
    directory "/var/cache/bind";
    //forwarders {
    //      0.0.0.0;
    //};
    //dnssec-validation auto;

    allow-query{any;};
    auth-nxdomain no;    # conform to RFC1035
    listen-on-v6 { any; };
};' > /etc/bind/named.conf.options

# berlint
echo `zone "operation.wise.E06.com" {
    type master;
    file "/etc/bind/operation/operation.wise.E06.com";
};` >> /etc/bind/named.conf.local

mkdir /etc/bind/operation

cp /etc/bind/db.local /etc/bind/operation/operation.wise.E06.com

# INI APAAN, IDA NGEBIND KE WISE WEH, bukan subdomainnya, htrsnya subdomain

# echo "\$TTL    604800
# @       IN      SOA     operation.wise.E06.com. root.operation.wise.E06.com. (
#                               2         ; Serial
#                          604800         ; Refresh
#                           86400         ; Retry
#                         2419200         ; Expire
#                          604800 )       ; Negative Cache TTL
# ;
# @       IN      NS      operation.wise.E06.com.
# @       IN      A       192.195.2.3 ; IP Eden
# www     IN      CNAME   operation.wise.E06.com.
# ns1     IN      A       192.195.2.3 ; IP Eden
# strix   IN      NS      ns1
# " > /etc/bind/wise/3.195.192.in-addr.arpa

# named -g

# Nomor 7 Untuk informasi yang lebih spesifik mengenai Operation Strix, buatlah subdomain melalui Berlint
# dengan akses strix.operation.wise.yyy.com dengan alias
# www.strix.operation.wise.yyy.com yang mengarah ke Eden

# Nomor 8 Setelah melakukan konfigurasi server, maka dilakukan konfigurasi Webserver.
# Pertama dengan webserver www.wise.yyy.com.
# Pertama, Loid membutuhkan webserver dengan DocumentRoot pada /var/www/wise.yyy.com

# Nomor 9 Setelah itu, Loid juga membutuhkan agar url www.wise.yyy.com/index.php/home dapat menjadi menjadi www.wise.yyy.com/home

# Nomor 10 Setelah itu, pada subdomain www.eden.wise.yyy.com, Loid membutuhkan
# penyimpanan aset yang memiliki DocumentRoot pada /var/www/eden.wise.yyy.com

# Nomor 11 Akan tetapi, pada folder /public, Loid ingin hanya dapat melakukan directory listing saja

# Nomor 12 Tidak hanya itu, Loid juga ingin menyiapkan error file 404.html pada folder /error untuk mengganti error kode pada apache

# Nomor 13 Loid juga meminta Franky untuk dibuatkan konfigurasi virtual host. Virtual host ini bertujuan untuk dapat
# mengakses file asset www.eden.wise.yyy.com/public/js menjadi www.eden.wise.yyy.com/js

# Nomor 14 Loid meminta agar www.strix.operation.wise.yyy.com hanya bisa diakses dengan
# port 15000 dan port 15500

# Nomor 15 dengan autentikasi username Twilight dan password opStrix dan file di /var/www/strix.operation.wise.yy

# Nomor 16 dan setiap kali mengakses IP Eden akan dialihkan secara otomatis ke www.wise.yyy.com

# Nomor 17 Karena website
# www.eden.wise.yyy.com semakin banyak pengunjung dan banyak modifikasi sehingga banyak gambar-gambar yang random,
# maka Loid ingin mengubah request gambar yang memiliki substring “eden” akan diarahkan menuju eden.png.
# Bantulah Agent Twilight dan Organisasi WISE menjaga perdamaian!