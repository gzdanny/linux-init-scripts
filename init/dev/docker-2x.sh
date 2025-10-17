#!/bin/bash
# 这是一个docker的范例，演示如何在最小化安装的服务器初始化两个容器，并完成文件映射和服务端口映射。
# 下载本脚本后，根据需要修改docker-compose.yml里端口映射部分 和 ufw放行端口部分，然后执行
# chmod +x docker-2x.sh
# ./docker-2x.sh

set -e

echo "📦 安装 Docker 和 Compose..."
sudo apt update
sudo apt install -y docker.io docker-compose

echo "👤 创建受限用户 dockeruser (UID 1500)..."
sudo groupadd -g 1500 dockergrp || true
sudo useradd -u 1500 -g dockergrp -s /usr/sbin/nologin dockeruser || true

echo "📁 创建实例目录结构并设置权限..."
for i in 01 02; do
  sudo mkdir -p /opt/xray/$i
  sudo touch /opt/xray/$i/config.json /opt/xray/$i/access.log /opt/xray/$i/error.log
  sudo chown -R 1500:1500 /opt/xray/$i
  sudo chmod -R 770 /opt/xray/$i
done

echo "📝 生成 docker-compose.yml（含注释）..."
cat <<EOF | sudo tee /opt/xray/docker-compose.yml > /dev/null
services:
  xray-01:  # 实例 01：主服务
    image: ghcr.io/xtls/xray-core
    container_name: xray-01
    user: "1500:1500"  # 使用宿主机 dockeruser (UID 1500)
    ports:
      - "9080:1080"  # 宿主机 9080 → 容器 1080（socks 服务）
      - "9081:1081"  # 宿主机 9081 → 容器 1081（vless 服务）
    volumes:
      - /opt/xray/01/config.json:/etc/xray/config.json
      - /opt/xray/01/access.log:/var/log/xray/access.log
      - /opt/xray/01/error.log:/var/log/xray/error.log
    restart: always

  xray-02:  # 实例 02：备用服务
    image: ghcr.io/xtls/xray-core
    container_name: xray-02
    user: "1500:1500"  # 使用宿主机 dockeruser (UID 1500)
    ports:
      - "9090:1080"  # 宿主机 9090 → 容器 1080（socks 服务）
      - "9091:1081"  # 宿主机 9091 → 容器 1081（vless 服务）
    volumes:
      - /opt/xray/02/config.json:/etc/xray/config.json
      - /opt/xray/02/access.log:/var/log/xray/access.log
      - /opt/xray/02/error.log:/var/log/xray/error.log
    restart: always
EOF

echo "🔐 配置 UFW 防火墙规则..."
sudo ufw allow 9080/tcp comment 'xray-01 socks'
sudo ufw allow 9081/tcp comment 'xray-01 vless'
sudo ufw allow 9090/tcp comment 'xray-02 socks'
sudo ufw allow 9091/tcp comment 'xray-02 vless'

echo "🔧 修复 UFW 默认禁止转发的问题..."
sudo bash -c 'sed -i "s/^DEFAULT_FORWARD_POLICY=.*/DEFAULT_FORWARD_POLICY=\"ACCEPT\"/" /etc/default/ufw'

# 插入 docker0 网桥转发规则（幂等处理）
if ! sudo grep -q "docker0" /etc/ufw/before.rules; then
  echo "🔧 添加 docker0 网桥转发规则到 /etc/ufw/before.rules..."

  sudo bash -c 'sed -i "/^*filter/a -A ufw-user-forward -i docker0 -j ACCEPT" /etc/ufw/before.rules'

  if ! sudo grep -q ":ufw-user-forward" /etc/ufw/before.rules; then
    sudo bash -c 'sed -i "/^*filter/a :ufw-user-forward - [0:0]" /etc/ufw/before.rules'
  fi
fi

echo "🔄 重载 UFW..."
sudo ufw reload

echo "🚀 启动 Xray 服务..."
cd /opt/xray
sudo docker-compose up -d

echo "✅ 初始化完成。请编辑 /opt/xray/01/config.json 和 /opt/xray/02/config.json 配置每个实例。"

echo "👥 检查当前用户是否在 dockergrp 组中..."
if ! id -nG "$USER" | grep -qw "dockergrp"; then
  echo "🔧 当前用户不在 dockergrp 中，正在添加..."
  sudo usermod -aG dockergrp "$USER"

  echo "⚠️ 注意：组变更将在下次登录后生效。"
  echo "👉 请重新登录终端或注销后再登录，以获得访问 /opt/xray/* 的权限。"
else
  echo "✅ 当前用户已在 dockergrp 中，无需修改。"
fi
