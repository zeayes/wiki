snowfake
==============================

#### 原理

参考Twitter的分布式ID生成方案，地址(https://github.com/twitter-archive/snowflake)。

采用 `zookeeper` 协调每个 `Generator` 进程的 `worker` `ID`

生成ID格式:

| 42位                           | 9位       | 12位   |
|--------------------------------|-----------|--------|
| 时间戳(毫秒，最长支持到2158年) | worker ID | 顺序号 |
