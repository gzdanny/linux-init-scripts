#!/bin/bash
set -e

# 获取当前脚本所在目录
BASE_URL="https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main"

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
        bash <(curl -fsSL ${BASE_URL}/init/debian-init.sh)
        ;;
    ubuntu)
        bash <(curl -fsSL ${BASE_URL}/init/ubuntu-init.sh)
        ;;
    *)
        echo "Unsupported OS. Currently only Debian and Ubuntu are supported."
        exit 1
        ;;
esac
