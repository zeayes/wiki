# -*- coding: utf-8 -*-


from sqlalchemy import create_engine, MetaData, Table

engine = create_engine('mysql://user:password@localhost:3306/test')
metadata = MetaData(engine)

conn = engine.connect()
# 创建数据库
conn.execute("create database db")
# 执行sql
raw_sql_string = "use db"
conn.execute(raw_sql_string)
conn.close()

#  通过表名获取表实例
table = Table('user', metadata, autoload=True)
# 自动创建表
table.create(checkfirst=True)
