#!/bin/bash
set -e

echo "=== Installing Docker + Portainer (Debian) ==="

# 更新系统并安装依赖
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg lsb-release ufw

# 安装 Docker 官方 GPG key 和仓库
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 将当前用户加入 docker 组（无需 sudo 执行 docker 命令）
sudo usermod -aG docker $USER

# 配置防火墙
sudo ufw allow 9000/tcp
sudo ufw allow 9443/tcp
sudo ufw reload

# 安装 Portainer
docker volume create portainer_data

docker run -d \
  -p 9000:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

echo "=== Docker + Portainer Installation Completed ==="
echo "Portainer Web UI is available at http://<server-ip>:9000 or https://<server-ip>:9443"
echo "You may need to log out and log back in for docker group permissions to take effect."
