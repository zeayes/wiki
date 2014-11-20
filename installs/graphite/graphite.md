#### 安转graphite
```sh
 pip install configobj
 
 pip install django-tagging==0.3.1 django==1.4 uwsgi
 
 pip install whisper carbon graphite-web
 
 cd /opt/graphite/webapp/graphite
 cp local_settings.py.example local_settings.py
 vim local_settings.py
 TIME_ZONE = 'Asia/Shanghai'
 
 cd /opt/graphite/conf
 cp carbon.conf.example carbon.conf
 cp storage-schemas.conf.example storage-schemas.conf
 vim /opt/graphite/lib/carbon/util.py
 # from twisted.scripts._twistd_unix import daemonize
 import daemonize

 bin/carbon-cache.py start
```


#### 安装pixman
```sh
wget http://cairographics.org/releases/pixman-0.22.0.tar.gz
tar xzf pixman-0.22.0.tar.gz && cd pixman-0.22.0
./configure --prefix=/usr/local/pixman-0.22.0
make -j 12 && make install
export PKG_CONFIG_PATH=/usr/local/pixman-0.22.0/lib/pkgconfig:$PKG_CONFIG_PATH
wget http://cairographics.org/releases/cairo-1.12.2.tar.xz
tar xJf cairo-1.12.2.tar.xz  && cd cairo-1.12.2
./autogen.sh
./configure --prefix=/usr/local/cairo-1.12.2
make -j 12 && make install
export PKG_CONFIG_PATH=/usr/local/cairo-1.12.2/lib/pkgconfig/:$PKG_CONFIG_PATH
wget http://www.cairographics.org/releases/py2cairo-1.10.0.tar.bz2
tar xjf py2cairo-1.10.0.tar.bz2 && cd py2cairo-1.10.0
./waf configure
./waf build
./waf install
```

#### 安装statsd
```
wget http://nodejs.org/dist/v0.10.33/node-v0.10.33.tar.gz
tar xzf node-v0.10.33.tar.gz && cd node-v0.10.33
./configure --prefix=/usr/local/node-v0.10.33
make -j 12 && make install
ln -s /usr/local/node-v0.10.33/bin/node /usr/bin/node
ln -s /usr/local/node-v0.10.33/bin/npm /usr/bin/npm
git clone https://github.com/etsy/statsd/
cd statsd
cp exampleConfig.js config.js
npm install nodeunit temp underscore
./run_tests.sh
node stats.js config.js
```
