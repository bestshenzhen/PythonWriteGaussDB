#!/bin/bash

# 更新系统并安装必要的工具
sudo apt update
sudo apt install -y wget tar curl

# 下载并安装JDK 1.8+
echo "Installing openjdk-21"
sudo apt install openjdk-21-jre-headless

# 下载并安装Nacos 2.4.3
echo "Installing Nacos 2.4.3"
NACOS_URL="https://github.com/alibaba/nacos/releases/download/2.4.3/nacos-server-2.4.3.tar.gz"
NACOS_DIR="/usr/local/nacos"

wget -q --show-progress $NACOS_URL -O nacos.tar.gz
tar -xzf nacos.tar.gz -C /usr/local
sudo mv /usr/local/nacos-server-2.4.3 $NACOS_DIR

wget https://github.com/SweetWuXiaoMei/nacos-plugin/releases/download/NacosOpenGaussPlugin/nacos-opengauss-datasource-plugin-ext-1.0.0.jar

mkdir -p $NACOS_DIR/nacos/plugins
cp nacos-opengauss-datasource-plugin-ext-1.0.0.jar $NACOS_DIR/nacos/plugins/

# 配置Nacos
echo "Configuring Nacos..."
NACOS_CONF="$NACOS_DIR/conf/application.properties"

# 示例配置（可以根据需要进行修改）
cat <<EOL > $NACOS_CONF
# ************************* Server Configs **************************
server.port=8848

# ************************* Naming Service *************************

spring.sql.init.platform=gaussdb
db.num=1
db.url.0=jdbc:opengauss://${HOST:IP}:${PORT:8000}/com_mysql_nacos?currentSchema=nacos
db.user=${DB_USER:root}
db.password=${DB_PASS:123456}
db.pool.config.driverClassName=org.opengauss.Driver

# ************************* Cluster Configs *************************
# 支持mysql cluster和raft cluster
# mysql cluster address example: 127.0.0.1:3306,127.0.0.2:3306,127.0.0.3:3306
# raft cluster address example: 127.0.0.1:8847,127.0.0.1:8848,127.0.0.1:8849
EOL

# 启动Nacos
echo "Starting Nacos..."
$NACOS_DIR/bin/startup.sh -m standalone

# 验证Nacos是否启动成功
echo "Nacos is starting, please wait a moment..."
sleep 10
curl -s http://localhost:8848/nacos | grep "Nacos"

if [ $? -eq 0 ]; then
    echo "Nacos installation and startup completed successfully!"
else
    echo "Failed to start Nacos. Please check the logs for more information."
fi

# 清理临时文件
rm jdk.tar.gz nacos.tar.gz
