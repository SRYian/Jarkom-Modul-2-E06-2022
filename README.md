# Jarkom-Modul-2-E06-2022

Repositori Jarkom Modul 2 kelompok E06

<details><summary>Anggota kelompok(click to show)</summary>
<p>

### Kelompok E06 :

1. Billy Brianto 5025201080 (nomor 1, 8-10)
2. Atha Dzaky Hidayanto 5025201269 (nomor 2, 3, 4)
3. Naily Khairiya 5025201244 (nomor 5, 6, 7)
</p>
</details>

## 1.

## 2.

## 3. Buat subdomain subdomain eden.wise.E06.com dengan alias www.eden.wise.E06.com

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

## 5.

## 6.
