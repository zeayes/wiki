#### rsync

##### 1.服务端
```sh
mkdir -p /etc/rsyncd/{conf,password}
cd /etc/rsyncd
uuidgen | awk '{print "example:"$1}' > password/example.secrets
chmod 600 password/example.secrets
vim conf/example.conf
rsync --daemon --config=/etc/rsyncd/conf/example.conf
```

##### 2.客户端
```sh
# copy服务端example.secrets里面的uuid到本地example.secrets
sudo chmod 600 example.secrets
rsync --port=31920 --password-file=example.secrets --exclude-from=exclude_file.txt -avzP test.txt project@192.168.0.105::project
# rsync具体命令参数
man rsync
```

##### 3.服务端rsync配置文件
```
# GLOBAL OPTIONS
pid file = /var/run/rsyncd.pid
port = 12345
address = 192.168.0.105

uid = root
gid = root

use chroot = no
read only = no
write only = no

hosts allow = 192.168.0.1/255.255.255.0 198.162.145.1 10.0.1.0/255.255.255.0
hosts deny = *
max connections = 5
# motd file = /etc/rsyncd/rsyncd.motd
log file = /var/log/rsyncd.log
transfer logging = yes
log format = %t %a %m %f %b
syslog facility = local3
timeout = 300

[example]
path=/home/example
list=yes
auth users = example
secrets file=/etc/rsyncd/password/example.secrets
comment = some description about this moudle
exclude = test1/ test2/
```