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

# 执行脚本的函数，支持 curl 或 wget
run_remote_script() {
    local url="$1"
    if command -v curl &>/dev/null; then
        bash <(curl -fsSL "$url")
    elif command -v wget &>/dev/null; then
        bash <(wget -qO- "$url")
    else
        echo "Error: Neither curl nor wget is installed."
        echo "Please install one of them manually and rerun this script."
        exit 1
    fi
}

case "$OS" in
    debian|ubuntu)
        run_remote_script "${BASE_URL}/debian-init.sh"
        ;;
    centos|rocky)
        run_remote_script "${BASE_URL}/centos-init.sh"
        ;;
    *)
        echo "Unsupported OS"
        exit 1
        ;;
esac
