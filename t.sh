wget http://coturn.net/turnserver/v4.5.0.7/turnserver-4.5.0.7-CentOS7.4-x86_64.tar.gz
tar xvfz turnserver-4.5.0.7-CentOS7.4-x86_64.tar.gz
cd turnserver-4.5.0.7
./install.sh



#编辑turnserver.conf
#key码生成
[root@izt4n3cqwumhn3nkbr5oxxz turnserver-4.5.0.7]# turnadmin -k -u zhangsan -r north.gov -p zhangsan
#证书生成
[root@izt4n3cqwumhn3nkbr5oxxz etc]# openssl req -x509 -newkey rsa:2048 -keyout /usr/local/etc/turn_server_pkey.pem -out /usr/local/etc/turn_server_cert.pem -days 9999 -nodes
[root@izt4n3cqwumhn3nkbr5oxxz ~]# vim /etc/turnserver/turnserver.conf
[root@izt4n3cqwumhn3nkbr5oxxz etc]# cat /etc/turnserver/turnserver.conf | grep -v "^#" | grep -v '^$'
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
[root@izt4n3cqwumhn3nkbr5oxxz ~]# turnserver -V -r 47.88.159.236:3478 -a -o -c /etc/turnserver/turnserver.conf