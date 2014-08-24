##### 安装MySQLdb
```sh
yum install python-devel
wget --no-check-certificate https://pypi.python.org/packages/source/M/MySQL-python/MySQL-python-1.2.5.zip#md5=654f75b302db6ed8dc5a898c625e030c
unzip MySQL-python-1.2.5.zip | cd MySQL-python-1.2.5
sed -i "14c\mysql_config = /usr/local/mysql-5.6.19/bin/mysql_config" site.cfg
python setup.py build
python setup.py install
```