import os
import psycopg2
from psycopg2 import sql

# 数据库连接配置
db_config = {
    'dbname': 'your_dbname',
    'user': 'your_username',
    'password': 'your_password',
    'host': 'your_host',
    'port': 'your_port'  # 默认端口是5432
}

# 读取当前目录下的SQL文件
sql_file_path = os.path.join(os.getcwd(), 'your_script.sql')

with open(sql_file_path, 'r') as file:
    sql_script = file.read()

# 连接到数据库
try:
    conn = psycopg2.connect(**db_config)
    cursor = conn.cursor()

    # 执行SQL脚本
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
