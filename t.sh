
apt-get update && apt-get install libssl-dev libevent-dev libhiredis-dev make -y    # install the dependencies

wget http://turnserver.open-sys.org/downloads/v4.5.1.1/turnserver-4.5.1.1.tar.gz
tar xvfz turnserver-4.5.1.1.tar.gz
cd turnserver-4.5.1.1

turnserver -a -o -v -n -u user:root -p 3478 -L INT_IP -r someRealm -X EXT_IP/INT_IP  --no-dtls --no-tls

* -X - your amazon instance's external IP, internal IP: EXT_IP/INT_IP
* -p - port to be used, default 3478
* -a - Use long-term credentials mechanism
* -o - Run server process as daemon
* -v - 'Moderate' verbose mode.
* -n - no configuration file
* --no-dtls - Do not start DTLS listeners
* --no-tls - Do not start TLS listeners
* -u - user credentials to be used
* -r - default realm to be used, need for TURN REST API


#编辑turnserver.conf
#key码生成
turnadmin -k -u zhangsan -r north.gov -p zhangsan

#证书生成
openssl req -x509 -newkey rsa:2048 -keyout /usr/local/etc/turn_server_pkey.pem -out /usr/local/etc/turn_server_cert.pem -days 9999 -nodes

vim /etc/turnserver/turnserver.conf

listening-device=eth0
listening-port=3478
relay-device=eth0
min-port=49152
max-port=65535
Verbose
fingerprint
lt-cred-mech
use-auth-secret
static-auth-secret=zhangsan #此处要和房间服务器配置时constants.py文件中的CODE_KEY保持一致。
user=zhangsan:0x934893f0ea44d4355cbfd48a40ae023c
user=zhangsan:zhangsan
stale-nonce=600
cert=/usr/local/etc/turn_server_cert.pem
pkey=/usr/local/etc/turn_server_pkey.pem
no-stdout-log
syslog
no-loopback-peers
no-multicast-peers
pidfile="/var/run/turnserver/turnserver.pid"
mobility
no-cli

#运行-r: 外部服务器地址

turnserver -V -r 47.88.159.236:3478 -a -o -c /etc/turnserver/turnserver.conf