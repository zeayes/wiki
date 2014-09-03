## elasticsearch

#### 1.安装JDK7
Apple官网提供的是JDK6，所以需要到Oracle官网下载mac版，下载完成后，根据提示安装即可。

#### 2.安装`elasticsearch`
##### 2.1 下载elasticsearch安装包后，解压就可以用了。
```sh
tar xzf elasticsearch-1.3.2.tar.gz 
cd elasticsearch-1.3.2
```
##### 2.2 以deamon方式启动
```
./bin/elasticsearch -d
```
##### 2.3 安装marvel插件
```
./bin/plugin -i elasticsearch/marvel/latest
http://192.168.0.101:9200/_plugin/marvel
```

#### 3. elasticsearch连接数据库
文档地址：https://github.com/jprante/elasticsearch-river-jdbc
##### 3.1 安装elasticsearch-river-jdbc
```sh
./bin/plugin --install jdbc --url http://xbib.org/repository/org/xbib/elasticsearch/plugin/elasticsearch-river-jdbc/1.3.0.4/elasticsearch-river-jdbc-1.3.0.4-plugin.zip
```

##### 3.2 安装MySQL JDBC
```sh
curl -o mysql-connector-java-5.1.28.zip -L 'http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.28.zip/from/http://cdn.mysql.com/'
cp mysql-connector-java-5.1.28-bin.jar $ES_HOME/plugins/jdbc/
```
##### 3.3 重启elasticsearch
```sh
./bin/elasticsearch
```
终端会提示`jdbc`已加载。
```sh
plugins ] [SuperPro] loaded [jdbc-1.3.0.4-247a6f5], sites []
```
在`$ES_HOME/bin`目录会多出`jdbc`目录:
```sh
ls bin/jdbc/
feeder       feeder.in.sh river        travis
```

##### 3.4 添加数据
```sh
curl -XPUT 'http://localhost:9200/_river/jdbc/_meta' -d '{"type":"jdbc", "jdbc":{"url":"jdbc:mysql://localhost:3306/user", "user": "root", "password":"", "sql":"select * from user_info_0"}}'
```

##### 3.5 查看添加的数据
```sh
http://localhost:9200/jdbc/_search?pretty&q=*
```

##### 3.6 删除数据
```sh
curl -XDELETE http://localhost:9200/_river/
curl -XDELETE http://localhost:9200/jdbc/
```

#### 4. 安装中文分词IK

##### 4.1 安装`maven`
```sh
brew install maven
```

##### 4.2 下载编译IK
```sh
wget https://github.com/medcl/elasticsearch-analysis-ik/archive/master.zip
unzip master.zip && cd elasticsearch-analysis-ik-master
mvn package
```

##### 4.3 安装IK到`elasticsearch`中
```sh
mkdir $ES_HOME/plugins/analysis-ik
cp target/elasticsearch-analysis-ik-1.2.7.jar $ES_HOME/plugins/analysis-ik
cp -rf config/ik $ES_HOME/config
```
在`elasticsearch.yml`中，加入`IK`配置
```sh
index.analysis.analyzer.ik.type : 'ik'
```
重启`elasticsearch`
```sh
./bin/elasticsearch
```

##### 4.4 测试`IK`分词效果
```sh
localhost:9200/question/_analyze?analyzer=ik&pretty=true&text=深圳市科技园赋安科技大厦
```
