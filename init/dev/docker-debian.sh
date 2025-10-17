#!/bin/bash
set -euo pipefail

echo "🔧 [1/6] 安装基础依赖..."
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release jq

echo "🔐 [2/6] 添加 Docker 官方 GPG 密钥..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "📦 [3/6] 添加 Docker 官方软件源..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "📥 [4/6] 安装 Docker 引擎及组件..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "⚙️ [5/6] 配置 Docker 禁用自动修改 iptables..."
sudo mkdir -p /etc/docker

# 如果 daemon.json 不存在或为空，初始化为 {}
if [ ! -s /etc/docker/daemon.json ]; then
  echo '{}' | sudo tee /etc/docker/daemon.json > /dev/null
fi

# 使用 jq 更新 iptables 字段为 false
sudo jq '.iptables = false' /etc/docker/daemon.json | \
  sudo tee /etc/docker/daemon.json.tmp > /dev/null
sudo mv /etc/docker/daemon.json.tmp /etc/docker/daemon.json

echo "🔄 [6/6] 重启 Docker 服务以应用配置..."
sudo systemctl restart docker

echo ""
echo "✅ Docker 安装与配置完成！"
echo "⚠️ 注意：已禁用 Docker 自动修改 iptables。"
echo "👉 请使用 UFW 显式开放容器端口，例如："
echo "    sudo ufw allow 8080/tcp"
echo ""
echo "📎 建议：你可以使用 docker-compose + 明确的端口映射 + UFW 控制，确保网络行为完全可控。"
