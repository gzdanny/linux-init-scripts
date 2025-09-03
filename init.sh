#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main"

# 检测 root 权限
if [ "$(id -u)" -ne 0 ]; then
    echo "请先以 root 权限运行此脚本，例如："
    echo "su -"
    echo "然后再次执行："
    echo "bash <(curl -fsSL ${BASE_URL}/init.sh)"
    exit 1
fi

# 检测操作系统
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            debian)
                echo "debian"
                ;;
            ubuntu)
                echo "ubuntu"
                ;;
            *)
                echo "unsupported"
                ;;
        esac
    else
        echo "unsupported"
    fi
}

OS=$(detect_os)
echo "Detected OS: $OS"

# 根据 OS 执行对应初始化脚本
case "$OS" in
    debian)
        echo "Executing Debian initialization..."
        bash <(curl -fsSL ${BASE_URL}/init/debian-init.sh)
        ;;
    ubuntu)
        echo "Executing Ubuntu initialization..."
        bash <(curl -fsSL ${BASE_URL}/init/ubuntu-init.sh)
        ;;
    *)
        echo "Unsupported OS. Currently only Debian and Ubuntu are supported."
        exit 1
        ;;
esac
