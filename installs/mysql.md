1. 安装`cmake`
```sh
wget -c http://www.cmake.org/files/v3.0/cmake-3.0.0.tar.gz
./configure --prefix=/usr/local/cmake-3.0.0
tar -zxvf cmake-3.0.0.tar.gz && cd cmake-3.0.0
make -j 4 && make install
ln -s /usr/local/cmake-3.0.0/bin/cmake /usr/local/bin/cmake
```


2. 安装`mysql`
```sh
cd /data/Downloads
wget http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.20.tar.gz
tar xzf mysql-5.6.20.tar.gz && cd mysql-5.6.20
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.6.20
make -j 8 && make install
# add mysql group&user
groupadd mysql
useradd -r -g mysql mysql
```

3. 配置`mysql`实例
```sh
mkdir -p /data/mysql_data/mysql_example/{data,innodb}
chown -R mysql:mysql /data/mysql_data/mysql_example
/usr/local/mysql-5.6.20/scripts/mysql_install_db --basedir=/usr/local/mysql-5.6.20 --datadir=/data/mysql_data/mysql_example/data --user=mysql
/usr/local/mysql-5.6.20/bin/mysqld_safe --defaults-file=/etc/mysql/mysql_example.cnf & >/dev/nulll &
/usr/local/mysql-5.6.20/bin/mysqladmin -u root -h 127.0.0.1 -P3306 password 'root'
```

4. 修改权限`SQL`语句
```sql
grant all privileges on *.* to 'root'@'192.168.107' identified by 'root' with grant option;
grant select, insert, update, delete, create, process, index, alter on *.* to 'lina'@'192.168.0.%' identified by 'password';
flush privileges;
show grants for root@'192.168.0.107';
show grants for 'lina'@'192.168.0.%';
```

5. 注意
> mysql配置中，`mysql`的`bind_address`首先要绑定到`0.0.0.0`，然后通过`mysqladmin`修改`root`用户的登陆权限后，再绑定到所需要绑定的地址。


6. 加载动态链接库
```sh
echo "/usr/local/mysql-5.6.20/lib/" > /etc/ld.so.conf.d/mysql.conf
ldconfig
```

7. 安装`MySQL-Python`
```sh
yum install python-devel
wget --no-check-certificate https://pypi.python.org/packages/source/M/MySQL-python/MySQL-python-1.2.5.zip#md5=654f75b302db6ed8dc5a898c625e030c
unzip MySQL-python-1.2.5.zip && cd MySQL-python-1.2.5
sed -i "14c\mysql_config = /usr/local/mysql-5.6.20/bin/mysql_config" site.cfg
python setup.py build
python setup.py install
```
