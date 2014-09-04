### Elasticsearch常见用法

`elasticsearch` 请求语法
```sh
curl -<REST Verb> <Node>:<Port>/<Index>/<Type>/<ID>
```

#### 一、索引

##### 1. 列出所有的索引
```sh
curl http://localhost:9200/_cat/indices?v
```
##### 2. 添加索引
```sh
curl -XPUT localhost:9200/indexname?pretty
```
##### 3. 删除索引
```sh
curl -XDELETE http://localhost:9200/indexname/
```

#### 二、River
`river`是`elasticsearch`获取数据源的插件服务，每一个`river`都有一个唯一的`name`，以及一个`type`，每一个`river`都需要实现一个包含`type`的接受`document`的`_meta`。
##### 1. 添加
```sh
curl -XPUT localhost:9200/_river/my_river/_meta -d '{
    "type" : "dummy"
}'
```
##### 2. 删除
```sh
curl -XDELETE 'localhost:9200/_river/my_river/'
```

##### 3. 状态
```sh
curl localhost:9200/_river/my_river/_status
```

#### 三、JDBC-RIVER实例
```sh
curl -XPUT  http://localhost:9200/_river/jdbc_index/_meta -d  '{
        "type": "jdbc",
        "jdbc": {
            "url": "jdbc:mysql://192.168.0.101:3306/user",
            "user": "root",
            "password": "",
            "sql": "SELECT user_id as \"_id\", username, email, mobile, create_time, update_time from user_info_0 where update_time + 300 > UNIX_TIMESTAMP(NOW())",
            "index": "indexname",
            "type": "typename",
            "schedule": "0/30 0-59 0-23 ? * *",
            "maxbulkactions": 200,
            }
        }'
```
**说明**
```
1. type：表示river插件的名称，即:jdbc。
2. jdbc：表示jdbc插件的参数。
3. jdbc.url，jdbc.user，jdbc.password：表示`jdbc`连接数据库的相关参数。
4. jdbc.sql：表示获取数据的SQL执行语句，此处_id会作为elasticsearch中document的id。
5. jdbc.index：表示elasticsearch的中索引。
6. jdbc.type：表示elasticsearch中jdbc.index中的类型。
7. jdbc.schedule：表示SQL语句定时执行调度方式。
8. jdbc. maxbulkactions：表示每次提交索引的数据数量。
```

**问题**：
##### 1. 修改SQL语句后，提交索引，虽然索引`_meta`下修改了，但是发现获取数据源的SQL语句没变，貌似是个BUG。
##### 2. 删除`indexname`后，虽然可以删除掉，但是当下次索引`_meta`执行后，`indexname`还是会存在。
```sh
curl -XDELETE http://192.168.0.101:9200/indexname/
curl http://192.168.0.101:9200/_cat/indices?v
```
##### 3. 修改SQL语句最好的办法有2中：
第一种：删除索引`indexname`和`_river`，然后重建。
```
curl -XDELETE http://192.168.0.101:9200/indexname/
curl -XDELETE http://192.168.0.101:9200/_river/
```
第二种：直接重建索引`indexname1`。

#### 四、QUERY语法

##### 1. 搜索范围
###### a. 系统内搜索
```sh
curl http://192.168.0.101:9200/_search?pretty&q=*
```
###### b.索引内搜索
```sh
curl http://192.168.0.101:9200/indexname/_search?pretty&q=*
curl http://192.168.0.101:9200/indexname1,indexname2/_search?pretty&q=*
```
###### c. 类型内搜索
```sh
curl http://192.168.0.101:9200/indexname/typename/_search?pretty&q=*
curl http://192.168.0.101:9200/indexname/typename1,typename2/_search?pretty&q=*
curl http://192.168.0.101:9200/indexname1,indexname2/typename/_search?pretty&q=*
```

```sh
curl -X GET http://192.168.0.101:9200/indexname/typename/_search -d '{"query":{"term": {"username": "19"}}}'
```

```sh
curl -X GET http://192.168.0.101:9200/indexname/typename/_search -d '{"query":{"term": {"username": "19"}}, "from": 0, "size": 5}'
```


#### 相关文档地址
1. [官网wiki](https://github.com/jprante/elasticsearch-river-jdbc)
2. [Four ways to index relational data in Elasticsearch](http://voormedia.com/blog/2014/06/four-ways-to-index-relational-data-in-elasticsearch)
3. [ElasticSearch and SQL Server are sitting in a tree](http://www.nitschinger.at/Elastic-Search-and-SQL-Server-are-sitting-in-a-tree)
4. [查询官方文档](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search.html)