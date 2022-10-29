apt-get update
y
apt-get install bind9 -y
y

echo 'zone "wise.E06.com" {
    type slave;
    masters { 192.195.3.2; }; // Masukan IP EniesLobby tanpa tanda petik
    file "/var/lib/bind/wise.E06.com";
};'>/etc/bind/named.conf.local
