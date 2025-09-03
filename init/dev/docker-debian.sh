#!/bin/bash
set -e

echo "=== Installing Docker + Portainer + Cockpit (Debian) ==="

# 更新系统并安装依赖
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg lsb-release ufw

# -------------------------------
# Docker 官方仓库安装 Docker 引擎
# -------------------------------
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 确认用户在 docker 组
if id -nG "$USER" | grep -qw docker; then
    echo -e "\033[32m用户 $USER 已在 docker 组中，继续后续部署。\033[0m"
else
    # 将当前用户加入 docker 组
    echo -e "\033[33m用户 $USER 不在 docker 组，正在添加...\033[0m"
    sudo usermod -aG docker "$USER"
    echo -e "\033[31m请注销并重新登录以应用权限，然后重新运行此脚本！\033[0m"
    exit 1
fi

# -------------------------------
# 配置 ufw 防火墙
# -------------------------------
sudo ufw allow 9000/tcp   # Portainer HTTP
sudo ufw allow 9443/tcp   # Portainer HTTPS
sudo ufw allow 9090/tcp   # Cockpit
sudo ufw reload

# -------------------------------
# 安装 Portainer
# -------------------------------
docker volume create portainer_data

docker run -d \
  -p 9000:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

# -------------------------------
# 安装 Cockpit
# -------------------------------
sudo apt install -y cockpit
sudo systemctl enable --now cockpit

echo "=== Docker + Portainer + Cockpit Installation Completed ==="
echo "Portainer Web UI: http://<server-ip>:9000 or https://<server-ip>:9443"
echo "Cockpit Web UI: http://<server-ip>:9090"
echo "Please log out and log back in for docker group permissions to take effect."
