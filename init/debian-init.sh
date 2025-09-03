#!/bin/bash
set -e

echo "=== Debian/Ubuntu Initialization Started ==="

# 检查 root
if [ "$(id -u)" -ne 0 ]; then
    echo "请先用 root 权限运行此脚本："
    echo "su -"
    echo "然后执行：bash init.sh"
    exit 1
fi

# 更新并安装软件
apt update -y
apt install -y openssh-server sudo ufw

# 获取非 root 用户
if [ -n "$SUDO_USER" ]; then
    USERNAME=$SUDO_USER
else
    USERNAME=$(logname 2>/dev/null || echo "")
fi

# 添加到 sudo 组
if [ -n "$USERNAME" ] && id "$USERNAME" &>/dev/null; then
    usermod -aG sudo "$USERNAME"
    echo "已将用户 $USERNAME 添加到 sudo 组"
else
    echo "未找到非 root 用户，请手动添加："
    echo "    usermod -aG sudo <用户名>"
fi

# 配置防火墙
ufw allow 22
echo "y" | ufw enable

# 启动 SSH
systemctl enable ssh
systemctl start ssh

echo "=== Debian/Ubuntu Initialization Completed ==="
