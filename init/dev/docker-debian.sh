#!/bin/bash
set -e

echo "🔧 Step 1: 清理旧版本..."
sudo apt-get remove -y docker docker.io docker-doc docker-compose podman-docker containerd runc || true

echo "📦 Step 2: 安装依赖..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

echo "🔐 Step 3: 添加 Docker GPG 密钥..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "📦 Step 4: 添加 Docker 官方源..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔄 Step 5: 更新索引并安装 Docker..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "👤 Step 6: 将当前用户加入 docker 组..."
sudo usermod -aG docker $USER
echo "⚠️ 请重新登录或运行 'newgrp docker' 以应用权限变更"

echo "🚀 Step 7: 启动 netshoot 容器用于网络测试..."
docker run --rm -it --name nettest -p 8080:80 nicolaka/netshoot bash


