#!/bin/bash
set -e

echo "=== CentOS/Rocky/AlmaLinux Initialization Started ==="

# 检查 root
if [ "$(id -u)" -ne 0 ]; then
    echo "请先用 root 权限运行此脚本："
    echo "su -"
    echo "然后执行：bash init.sh"
    exit 1
fi

# 检测包管理器
if command -v dnf &>/dev/null; then
    PKG_CMD="dnf install -y"
    UPDATE_CMD="dnf makecache -y"
elif command -v yum &>/dev/null; then
    PKG_CMD="yum install -y"
    UPDATE_CMD="yum makecache -y"
else
    echo "Error: No supported package manager found (dnf or yum)"
    exit 1
fi

# 安装 curl（如未安装）
if ! command -v curl &>/dev/null; then
    echo "curl 未安装，正在安装 curl..."
    $PKG_CMD curl
fi

# 更新缓存并安装基础软件
$UPDATE_CMD
$PKG_CMD openssh sudo firewalld

# 获取非 root 用户
if [ -n "$SUDO_USER" ]; then
    USERNAME=$SUDO_USER
else
    USERNAME=$(logname 2>/dev/null || echo "")
fi

# 添加到 wheel 组
if [ -n "$USERNAME" ] && id "$USERNAME" &>/dev/null; then
    usermod -aG wheel "$USERNAME"
    echo "已将用户 $USERNAME 添加到 wheel 组"
else
    echo "未找到非 root 用户，请手动添加："
    echo "    usermod -aG wheel <用户名>"
fi

# 启动并开机自启 firewalld
systemctl enable --now firewalld

# 开放 SSH 端口
firewall-cmd --permanent --add-port=22/tcp
firewall-cmd --reload

# 启动并开机自启 SSH
systemctl enable --now sshd

echo "=== CentOS/Rocky/AlmaLinux Initialization Completed ==="
