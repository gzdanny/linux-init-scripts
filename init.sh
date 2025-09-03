#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init"

# 检测操作系统
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            debian|ubuntu)
                echo "$ID"
                ;;
            centos)
                echo "centos"
                ;;
            rocky)
                echo "rocky"
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

if [ "$OS" = "unsupported" ]; then
    echo "Unsupported OS. Currently only Debian and Ubuntu are supported."
    exit 1
fi

# 调用通用初始化脚本
bash <(curl -fsSL ${BASE_URL}/common.sh) "$OS"
