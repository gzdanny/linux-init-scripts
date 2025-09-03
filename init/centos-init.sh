#!/bin/bash
set -e

echo "=== CentOS/Rocky Initialization Started ==="

# 检查 root
if [ "$(id -u)" -ne 0 ]; then
    echo "请先用 root 权限运行此脚本："
    echo "su -"
    echo "然后执行：bash init.sh"
    exit 1
fi

# 更新并安装软件
yum makecache -y
yum install -y openssh sudo firewalld

# 获取非 root 用户
if [ -n "$SUDO_USER" ]; then
    USERNAME=$SUDO_USER
else
    USERNAME=$(logname 2>/dev/null || echo "")
fi

# 添加到 sudo 组
if [ -n "$USERNAME" ] && id "$USERNAME" &>/dev/null; then
    usermod -aG wheel "$USERNAME"  # CentOS/Rocky 使用 wheel 组
    echo "已将用户 $USERNAME 添加到 wheel 组"
else
    echo "未找到非 root 用户，请手动添加："
    echo "    usermod -aG wheel <用户名>"
fi

# 配置防火墙
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-port=22/tcp
firewall-cmd --reload

# 启动 SSH
systemctl enable sshd
systemctl start sshd

echo "=== CentOS/Rocky Initialization Completed ==="
