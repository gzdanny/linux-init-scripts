#!/bin/bash
set -e

# $1 = OS 类型 (debian / ubuntu)
init_linux() {
    OS=$1
    echo "=== $OS Initialization Started ==="

    # 确保 root
    if [ "$(id -u)" -ne 0 ]; then
        echo "请先用 root 权限运行此脚本："
        echo "su -"
        echo "然后执行：bash init.sh"
        exit 1
    fi

    # 更新软件包索引
    apt update -y

    # 安装基础工具
    apt install -y openssh-server sudo ufw

    # 获取当前非 root 用户
    if [ -n "$SUDO_USER" ]; then
        CURRENT_USER=$SUDO_USER
    else
        CURRENT_USER=$(logname 2>/dev/null || echo "")
    fi

    # 添加 sudo 用户
    if [ -n "$CURRENT_USER" ] && id "$CURRENT_USER" &>/dev/null; then
        usermod -aG sudo "$CURRENT_USER"
        echo "已将用户 $CURRENT_USER 添加到 sudo 组"
    else
        echo "未找到非 root 用户，请用下面命令手动添加："
        echo "usermod -aG sudo <用户名>"
    fi

    # 防火墙配置
    ufw allow 22
    echo "y" | ufw enable

    # 启动 SSH 服务
    systemctl enable ssh
    systemctl start ssh

    echo "=== $OS Initialization Completed ==="
    echo "SSH 已启动，22 端口已放行，防火墙已启用"
}
