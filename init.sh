#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init"

# 检测 OS
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

case "$OS" in
    debian)
        bash <(curl -fsSL ${BASE_URL}/debian-init.sh)
        ;;
    ubuntu)
        bash <(curl -fsSL ${BASE_URL}/debian-init.sh)  # Ubuntu 使用 Debian 脚本
        ;;
    centos)
        bash <(curl -fsSL ${BASE_URL}/centos-init.sh)
        ;;
    rocky)
        bash <(curl -fsSL ${BASE_URL}/centos-init.sh)  # Rocky 使用 CentOS 脚本
        ;;
    *)
        echo "Unsupported OS"
        exit 1
        ;;
esac
