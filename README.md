# Jarkom-Modul-2-E06-2022

Repositori Jarkom Modul 2 kelompok E06

<details><summary>Anggota kelompok(click to show)</summary>
<p>

### Kelompok E06 :

1. Billy Brianto 5025201080
2. Atha Dzaky Hidayanto 5025201269
3. Naily Khairiya 5025201244
</p>
</details>

## 1. WISE akan dijadikan sebagai DNS Master, Berlint akan dijadikan DNS Slave, dan Eden akan digunakan sebagai Web Server. Terdapat 2 Client yaitu SSS, dan Garden. Semua node terhubung pada router Ostania, sehingga dapat mengakses internet

## 2. Untuk mempermudah mendapatkan informasi mengenai misi dari Handler, bantulah Loid membuat website utama dengan akses wise.yyy.com dengan alias www.wise.yyy.com pada folder wise

## 3. Setelah itu ia juga ingin membuat subdomain eden.wise.yyy.com dengan alias www.eden.wise.yyy.com yang diatur DNS-nya di WISE dan mengarah ke Eden

Untuk subdomain dapat dilakukan dengan command berikut yang menambahkan line pada file wise.E06.com

```bash
echo "eden     IN      A   192.195.2.3">>/etc/bind/wise/wise.E06.com
```

```bash
echo "
ns1     IN      A       192.195.2.3 ; IP Eden
super   IN      NS      ns1
" >> /etc/bind/wise/wise.E06.com
```

Selanjutnya dapat dilakukan config lebih lanjut pada eden.wise.E06.com

```bash
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
```

## 4. Buat juga reverse domain untuk domain utama

untuk membuat reverse domain, daoat dilakukan extra config dalam named.conf.local

```bash
echo 'zone "3.195.192.in-addr.arpa" {
    type master;
    file "/etc/bind/wise/3.195.192.in-addr.arpa";
};' >> /etc/bind/named.conf.local
```

Sesudahnya, dapat dilakukan config ke reverse domain tersebut dengan memasukan record PTR untuk reverse domain

```bash
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
```

## 5. Agar dapat tetap dihubungi jika server WISE bermasalah, buatlah juga Berlint sebagai DNS Slave untuk domain utama

## 6. Karena banyak informasi dari Handler, buatlah subdomain yang khusus untuk operation yaitu operation.wise.yyy.com dengan alias www.operation.wise.yyy.com yang didelegasikan dari WISE ke Berlint dengan IP menuju ke Eden dalam folder operation

## 7. Untuk informasi yang lebih spesifik mengenai Operation Strix, buatlah subdomain melalui Berlint dengan akses strix.operation.wise.yyy.com dengan alias

www.strix.operation.wise.yyy.com yang mengarah ke Eden

## 8. Setelah melakukan konfigurasi server, maka dilakukan konfigurasi Webserver. Pertama dengan webserver www.wise.yyy.com. Pertama, Loid membutuhkan webserver dengan DocumentRoot pada /var/www/wise.yyy.com

## 9. Setelah itu, Loid juga membutuhkan agar url www.wise.yyy.com/index.php/home dapat menjadi menjadi www.wise.yyy.com/home

## 10. Setelah itu, pada subdomain www.eden.wise.yyy.com, Loid membutuhkan penyimpanan aset yang memiliki DocumentRoot pada /var/www/eden.wise.yyy.com

## 11. Akan tetapi, pada folder /public, Loid ingin hanya dapat melakukan directory listing saja

## 12. Tidak hanya itu, Loid juga ingin menyiapkan error file 404.html pada folder /error untuk mengganti error kode pada apache

## 13. Loid juga meminta Franky untuk dibuatkan konfigurasi virtual host. Virtual host ini bertujuan untuk dapat mengakses file asset www.eden.wise.yyy.com/public/js menjadi www.eden.wise.yyy.com/js

## 14. Loid meminta agar www.strix.operation.wise.yyy.com hanya bisa diakses dengan port 15000 dan port 15500

## 15. dengan autentikasi username Twilight dan password opStrix dan file di /var/www/strix.operation.wise.yyy

## 16. dan setiap kali mengakses IP Eden akan dialihkan secara otomatis ke www.wise.yyy.com

## 17. Karena website www.eden.wise.yyy.com semakin banyak pengunjung dan banyak modifikasi sehingga banyak gambar-gambar yang random, maka Loid ingin mengubah request gambar yang memiliki substring “eden” akan diarahkan menuju eden.png. Bantulah Agent Twilight dan Organisasi WISE menjaga perdamaian!
