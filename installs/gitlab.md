### gitlab安装文档

安装环境为CentOS 6.5。

```sh
$ uname -a
Linux localhost.localdomain 2.6.32-431.el6.x86_64 #1 SMP Fri Nov 22 03:15:09 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
```

##### 安装库文件

```sh
yum install patch gcc-c++ cmake readline-devel zlib-devel libffi-devel openssl-devel make autoconf automake libtool bison libxml2-devel libxslt-devel libyaml-devel python python-docutils  bison-devel ncurses-devel pcre-devel
```

##### 安装nginx
```sh
cd /data/Downloads
wget http://nginx.org/download/nginx-1.6.0.tar.gz
tar zxvf nginx-1.6.0.tar.gz
cd nginx-1.6.0
./configure --prefix=/usr/local/nginx-1.6.0 --with-http_stub_status_module --with-http_gzip_static_module --with-http_ssl_module --with-http_realip_module --with-http_secure_link_module
make -j 4 && make install
```

##### 安装git-1.8.0
```sh
yum install -y perl-ExtUtils-MakeMaker gettext-devel
wget http://distfiles.macports.org/git-core/git-1.8.0.tar.gz
tar xzf git-1.8.0.tar.gz | cd git-1.8.0
./configure --prefix=/usr/local/git-1.8.0
make && make install
cp /usr/local/git-1.8.0/bin/git /usr/local/bin/
```

##### 安装mysql
```sh
groupadd mysql
useradd -r -g mysql mysql
wget http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.19.tar.gz
tar -zxvf mysql-5.6.19.tar.gz | cd mysql-5.6.19
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.6.19
make -j 4 && make install
mkdir -p /data/mysql/data
chown -R mysql.mysql /data/mysql
/usr/local/mysql-5.6.19/scripts/mysql_install_db --basedir=/usr/local/mysql-5.6.19 --datadir=/data/mysql/data --user=mysql --ldata=/var/lib/mysql
cd /var/run | mkdir mysqld
chown -R mysql.mysql mysqld
/usr/local/mysql-5.6.19/bin/mysqld_safe &
echo "/usr/local/mysql-5.6.19/lib/" > /etc/ld.so.conf.d/mysql.conf
ldconfig
```

##### 安装redis
```sh
wget http://download.redis.io/releases/redis-2.8.13.tar.gz
tar -zxvf redis-2.8.13.tar.gz && cd redis-2.8.13
make
make PREFIX=/usr/local/redis-2.8.13 install
ln -s /usr/local/redis-2.8.13/bin/redis-cli /usr/bin/
cd /etc/redis/
wget http://wiki.zwc.me/raw-attachment/wiki/docs/install/redis/redis_46379.conf
mkdir -p /data/redis_46379/logs
/usr/local/redis-2.8.13/bin/redis-server /etc/redis/redis_46379.conf
```

##### 安装ruby
```sh
wget http://ftp.ruby-lang.org/pub/ruby/ruby-2.0-stable.tar.gz
tar xzf ruby-2.0-stable.tar.gz && cd ruby-2.0.0-p481
./configure --prefix=/usr/local/ruby-2.0.0 --disable-install-rdoc
make &&　make install
替换ruby源
gem sources --remove https://rubygems.org/
gem sources -a https://ruby.taobao.org/
gem sources -l
安装bundler
gem install bundler --no-doc
```

##### [安装gitlab](https://github.com/gitlabhq/gitlab-recipes/tree/master/install/centos)
1. 添加`git`用户

	```sh
	adduser --system --shell /bin/bash --comment 'GitLab' --create-home --home-dir /home/git/ git
	```
2. 创建数据库

	```sh
	CREATE DATABASE IF NOT EXISTS `gitlabhq_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;
	GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `gitlabhq_production`.* TO 'git'@'localhost';
	```
3. 安装gitlab

	```sh
	git clone https://gitlab.com/gitlab-org/gitlab-ce.git -b 7-1-stable gitlab
	cd gitlab
	# 更改相关的配置
	cp config/gitlab.yml.example config/gitlab.yml
	cp config/resque.yml.example config/resque.yml
	cp config/unicorn.rb.example config/unicorn.rb
	cp config/database.yml.mysql config/database.yml
	chmod o-rwx config/database.yml
	cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb
	chown -R git {log,tmp}
    chmod -R u+rwX  {log,tmp}
    chmod -R u+rwX  tmp/{pids,sockets}
    chmod -R u+rwX  public/uploads
    # 安装Gems
    bundle install --deployment --without development test postgres aws
	```
4. git配置

	```sh
	git config --global user.name "GitLab"
	git config --global user.email "gitlab@localhost"
	git config --global core.autocrlf input
	```
5. 安装gitlab-shell

	```sh
	bundle exec rake gitlab:shell:install[v1.9.6] REDIS_URL=redis://localhost:6379 RAILS_ENV=production
	restorecon -Rv /home/git/.ssh
	```
6. 配置gitlab运行环境

	```sh
	# 初始化数据库
	bundle exec rake gitlab:setup RAILS_ENV=production
	# 检查服务状态
	bundle exec rake gitlab:env:info RAILS_ENV=production
	# 编译组件
	bundle exec rake assets:precompile RAILS_ENV=production
	```
7. 安装gitlab服务脚本

	```sh
	wget -O /etc/init.d/gitlab https://gitlab.com/gitlab-org/gitlab-recipes/raw/master/init/sysvinit/centos/gitlab-unicorn
	chmod +x /etc/init.d/gitlab
	chkconfig --add gitlab
	chkconfig gitlab on
	cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab
	service gitlab start
	```
8. 配置nginx

	```sh
	# 下载配置文件并更改
	wget -O /usr/local/nginx-1.6.0/conf/sites/gitlab.conf https://gitlab.com/gitlab-org/gitlab-ce/raw/master/lib/support/nginx/gitlab-ssl
	usermod -a -G git nginx
	chmod g+rx /home/git/
	/etc/init.d/nginx 
	```
	
	
##### 安装问题
1. `git clone/push`权限问题
	```
	git clone git@gitlab.exmaple.com:zeayes/test.git
	Cloning into 'test'...
	Access denied.
	fatal: Could not read from remote repository.
	Please make sure you have the correct access rights
	and the repository exists.
	```
	
	查看日志`gitlab`的`sidekip.log`：
	```
	home/git/gitlab-shell/lib/gitlab_keys.rb:87:in `initialize':Permission denied - /home/git/.ssh/authorized_keys.lock (Errno::EACCES)
	from /home/git/gitlab-shell/lib/gitlab_keys.rb:87:in `open'
	from /home/git/gitlab-shell/lib/gitlab_keys.rb:87:in `lock'
	from /home/git/gitlab-shell/lib/gitlab_keys.rb:65:in `rm_key'
	from /home/git/gitlab-shell/lib/gitlab_keys.rb:21:in `exec'
	from /home/git/gitlab-shell//bin/gitlab-keys:21:in `<main>'
2014-08-25T03:03:54Z 2746 TID-ovuxd18ic GitlabShellWorker JID-d712a55020c632580a705e43 INFO: done: 0.492 sec
	```
	
	查看文件权限：
	```
	ll ~/.ssh/authorized_keys.lock
	-rw------- 1 git git 527 8月  25 10:49 /home/git/.ssh/authorized_keys
	```
	
	修改文件权限：
	```
	chmod 760 ~/.ssh/authorized_keys.lock
	```
	
	再次`git clone/push` OK。



