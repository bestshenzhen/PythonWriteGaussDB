import os
import psycopg2
from psycopg2 import sql

# 从环境变量中获取用户名和密码。
host_env = os.getenv('HOST')
user_env = os.getenv('DB_USER')
password_env = os.getenv('DB_PASS')

# 读取当前目录下的SQL文件
sql_file_path = os.path.join(os.getcwd(), 'your_script.sql')

with open(sql_file_path, 'r') as file:
    sql_script = file.read()

# 连接到数据库
try:
    # 创建连接对象。
    conn=psycopg2.connect(database="postgres", user=user_env, password=password_env, host=host_env, port="8000")
    
    # 打开自动提交
    con.autocommit = True 
    cur=conn.cursor() #创建指针对象。

    # 执行SQL脚本
    # 1.NACOS使用到GaussDB相关配置脚本
    cursor.execute("DROP database IF EXISTS com_mysql_nacos;")
    cursor.execute("CREATE database com_mysql_nacos dbcompatibility = 'B';")
    con.autocommit = False
    
    # 2.执行nacos数据表配置脚本
    cursor.execute(sql.SQL(sql_script))

    # 提交事务
    conn.commit()

    print("SQL script executed successfully.")

except (Exception, psycopg2.DatabaseError) as error:
    print(f"Error: {error}")
    if conn is not None:
        conn.rollback()

finally:
    if cursor:
        cursor.close()
    if conn:
        conn.close()
