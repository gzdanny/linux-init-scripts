#!/bin/bash
BASE_URL="https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main"

# 检测操作系统
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            debian|ubuntu)
                echo "$ID"
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
    echo "Unsupported OS"
    exit 1
fi

# 下载并执行通用初始化脚本
bash <(curl -fsSL ${BASE_URL}/init/common.sh) "$OS"
