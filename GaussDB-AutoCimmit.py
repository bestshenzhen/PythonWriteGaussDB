import os
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

# 从环境变量中获取用户名和密码。

# 创建连接对象。
conn = psycopg2.connect(database="db_wbb", user="wbb", password="Gauss_123", host="192.168.69.111", port="8000")
conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
cur = conn.cursor() #创建指针对象。

# 创建连接对象（SSl连接）。
#conn = psycopg2.connect(dbname="database", user=user, password=password, host="localhost", port=port,
#         sslmode="verify-ca", sslcert="client.crt",sslkey="client.key",sslrootcert="cacert.pem")


# 创建表。
cur.execute("drop database if exists abc;")
cur.execute("create database abc;")

# 关闭连接。
cur.close()
conn.close()
