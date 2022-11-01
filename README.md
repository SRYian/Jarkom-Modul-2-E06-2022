# Jarkom-Modul-2-E06-2022

Repositori Jarkom Modul 2 kelompok E06

<details><summary>Anggota kelompok(click to show)</summary>
<p>

### Kelompok E06 :
1. Billy Brianto            5025201080  
2. Atha Dzaky Hidayanto    5025201269 
3. Naily Khairiya            5025201244
</p>
</details>


![layout](https://user-images.githubusercontent.com/72675854/198836914-1877474f-ca78-4558-a860-cc4f3ed9001c.jpg)

## 1. WISE akan dijadikan sebagai DNS Master, Berlint akan dijadikan DNS Slave, dan Eden akan digunakan sebagai Web Server. Terdapat 2 Client yaitu SSS, dan Garden. Semua node terhubung pada router Ostania, sehingga dapat mengakses internet 


Edit Network Configuration

#### Ostania
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.195.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.195.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.195.3.1
	netmask 255.255.255.0

```


#### Wise
```
auto eth0
iface eth0 inet static
	address 192.195.3.2
	netmask 255.255.255.0
	gateway 192.195.3.1
```

#### SSS
```
auto eth0
iface eth0 inet static
	address 192.195.1.2
	netmask 255.255.255.0
	gateway 192.195.1.1
```


#### Garden
```
auto eth0
iface eth0 inet static
	address 192.195.1.3
	netmask 255.255.255.0
	gateway 192.195.1.1
```


#### Berlint 
```
auto eth0
iface eth0 inet static
	address 192.195.2.2
	netmask 255.255.255.0
	gateway 192.195.2.1
```


#### Eden
```
auto eth0
iface eth0 inet static
	address 192.195.2.3
	netmask 255.255.255.0
	gateway 192.195.2.1
```


Agar node-node lainnya dapat mengakses internet, jalankan command berikut dan gunakan IP DNS dari Ostania.
```
nameserver 192.168.122.1 > /etc/resolv.conf
```

Lakukan untuk setiap node agar terhubung dan mendapatkan koneksi internet.

Lakukan testing dengan ping ke google.com untuk mengetahui apakah sudah terkoneksi atau belum.
Contonya pada Eden:
<img width="395" alt="image" src="https://user-images.githubusercontent.com/72675854/198837308-46681652-5a17-4031-8538-0fb8f73086f0.png">


## 2. Untuk mempermudah mendapatkan informasi mengenai misi dari Handler, bantulah Loid membuat website utama dengan akses wise.yyy.com dengan alias www.wise.yyy.com pada folder wise 

Lakukan instalasi bind9 terlebih dahulu pada Wise. Berikut command yang harus dijalankan
```
apt-get update
apt-get install bind9 -y
```

setelah selesai, buat domain wise.E06.com. 
```
echo 'zone "wise.E06.com" {
    type master;
    file "/etc/bind/wise/wise.E06.com";
};'>/etc/bind/named.conf.local
```

Buat folder baru, yaitu /etc/bind/wise
```
mkdir /etc/bind/wise
```

restart dengan

``` 
service bind9 restart
```

Lakukan konfiggurasi pada /etc/bind/wise/wise.E06.com sebagai berikut
```
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

```


Kemudian tambahkan
```
echo "www     IN      CNAME   wise.E06.com.">>/etc/bind/wise/wise.E06.com
```

restart kembali dengan

```
service bind9 restart
```


## 3. Setelah itu ia juga ingin membuat subdomain eden.wise.yyy.com dengan alias www.eden.wise.yyy.com yang diatur DNS-nya di WISE dan mengarah ke Eden 

## 4. Buat juga reverse domain untuk domain utama 

## 5. Agar dapat tetap dihubungi jika server WISE bermasalah, buatlah juga Berlint sebagai DNS Slave untuk domain utama

## 6. Karena banyak informasi dari Handler, buatlah subdomain yang khusus untuk operation yaitu operation.wise.yyy.com dengan alias www.operation.wise.yyy.com yang didelegasikan dari WISE ke Berlint dengan IP menuju ke Eden dalam folder operation 

## 7. Untuk informasi yang lebih spesifik mengenai Operation Strix, buatlah subdomain melalui Berlint dengan akses strix.operation.wise.yyy.com dengan alias www.strix.operation.wise.yyy.com yang mengarah ke Eden 

Menambah subdomain operation dan strix.operation pada server wise dengan :
```
echo	"ns1       IN      A       192.193.3.2
	ns2	    IN	A	  192.193.3.2
	operation IN      NS      ns1
	strix.operation	IN	NS	ns2" >> /etc/bind/wise/wise.E06.com

```

pada server berlint :
```
echo 'zone "operation.wise.E06.com" {
	    type master;
	    file "/etc/bind/operation/operation.wise.E06.com";
	};

	zone "strix.operation.wise.E06.com" {
	    type master;
	    file "/etc/bind/operation/strix.operation.wise.E06.com";
	};' >> /etc/bind/named.conf.local
```

kemudian lakukan konfigurasi pada operation.wise.E06.com
```
echo "$TTL    604800
	@       IN      SOA     operation.wise.E06.com. root.operation.wise.E06.com. (
			     2022102601         ; Serial
				 604800         ; Refresh
				  86400         ; Retry
				2419200         ; Expire
				 604800 )       ; Negative Cache TTL
	;
	@       	IN      NS      operation.wise.E06.com.
	@       	IN      A       192.193.2.3
	www     	IN      CNAME   operation.wise.E06.com." > /etc/bind/operation/operation.wise.E06.com
```

Selanjutnya lakukan konfigurasi pada strix.operation.wise.E06.com
```
echo	"$TTL    604800
	@       IN      SOA     strix.operation.wise.E06.com. root.strix.operation.wise.E06.com. (
			     2022102601         ; Serial
				 604800         ; Refresh
				  86400         ; Retry
				2419200         ; Expire
				 604800 )       ; Negative Cache TTL
	;
	@       	IN      NS      strix.operation.wise.E06.com.
	@       	IN      A       192.193.3.2
	www     	IN      CNAME   strix.operation.wise.E06.com." > /etc/bind/operation/strix.operation.wise.E06.com
```

kemudian pada wise dan berlint lakukan berikut:
```
echo 	"options {
		directory "/var/cache/bind";
		allow-query{any;};
		auth-nxdomain no;    
		listen-on-v6 { any; };
	};" > /etc/bind/named.conf.options
```
lakukan restart pada kedua server

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
