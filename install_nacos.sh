#!/bin/bash

# 更新系统并安装必要的工具
sudo apt update
sudo apt install -y wget tar curl

# 下载并安装JDK
# echo "Installing openjdk-21"
# sudo apt install openjdk-21-jre-headless

echo "Installing jdk-23"
JDK_URL="https://download.oracle.com/java/23/latest/jdk-23_linux-x64_bin.tar.gz"
JDK_TEMP="jdk.tar.gz"
 
# 下载 JDK
wget -q --show-progress $JDK_URL -O $JDK_TEMP
 
# 解压 JDK 并获取实际目录名
tar -xzf $JDK_TEMP -C /usr/local --strip-components=1
JDK_DIR=$(ls /usr/local | grep -E "jdk-[0-9]+\.[0-9]+\.[0-9]+(_[0-9]+)?$" | sort -V | tail -n 1)
 
# 清理下载的 tar.gz 文件
rm $JDK_TEMP
 
# 设置 JAVA_HOME 环境变量
echo "export JAVA_HOME=/usr/local/$JDK_DIR" >> ~/.bashrc
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc
 
# 验证 JDK 安装
java -version

# 下载并安装Nacos 2.4.3
echo "Installing Nacos 2.4.3"
NACOS_URL="https://github.com/alibaba/nacos/releases/download/2.4.3/nacos-server-2.4.3.tar.gz"
NACOS_DIR="/usr/local/nacos"

wget -q --show-progress $NACOS_URL -O nacos.tar.gz \
tar -xzf nacos.tar.gz -C /usr/local

wget https://github.com/SweetWuXiaoMei/nacos-plugin/releases/download/NacosOpenGaussPlugin/nacos-opengauss-datasource-plugin-ext-1.0.0.jar

mkdir -p $NACOS_DIR/nacos/plugins
cp nacos-opengauss-datasource-plugin-ext-1.0.0.jar $NACOS_DIR/nacos/plugins/

# 配置Nacos
echo "Configuring Nacos..."

# 示例配置（可以根据需要进行修改）
cp application.properties  $NACOS_DIR/conf/application.properties

# 启动Nacos
echo "Starting Nacos..."
cd $NACOS_DIR/bin
./startup.sh -m standalone

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
