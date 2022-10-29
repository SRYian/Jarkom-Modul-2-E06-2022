
apt-get update
y
apt-get install dnsutils
y

nameserver 192.195.3.2 > /etc/resolv.conf

ping www.wise.E06.com -c 3
ping wise.E06.com -c 3
host -t PTR 192.195.3.2
ping www.eden.wise.E06.com -c 3
ping eden.wise.E06.com -c 3
ping operation.wise.E06.com -c 3
